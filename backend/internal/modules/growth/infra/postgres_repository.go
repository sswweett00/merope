package infra

import (
	"context"
	"fmt"
	"math"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"

	"local/merope/internal/modules/growth/domain"
)

type PostgresGrowthRepository struct{ pool *pgxpool.Pool }

func NewPostgresGrowthRepository(pool *pgxpool.Pool) *PostgresGrowthRepository {
	return &PostgresGrowthRepository{pool: pool}
}

func (r *PostgresGrowthRepository) CreateReferral(ctx context.Context, ref *domain.Referral) error {
	_, err := r.pool.Exec(ctx, `
		INSERT INTO growth_referrals(referrer_id, referred_id, code, reward_granted)
		VALUES($1,$2,$3,FALSE)
		ON CONFLICT(referrer_id, referred_id) DO NOTHING
	`, ref.ReferrerID, ref.ReferredID, ref.Code)
	return err
}

func (r *PostgresGrowthRepository) UpdateInfluence(ctx context.Context, userID string, delta float64) error {
	_, err := r.pool.Exec(ctx, `
		INSERT INTO progression_profiles(user_id, reputation)
		VALUES($1, ROUND($2)::bigint)
		ON CONFLICT(user_id) DO UPDATE
		SET reputation=GREATEST(0, progression_profiles.reputation+ROUND($2)::bigint),
		    updated_at=NOW()
	`, userID, delta)
	return err
}

func (r *PostgresGrowthRepository) GetLeaderboard(ctx context.Context, limit int) ([]*domain.InfluenceRank, error) {
	if limit <= 0 || limit > 100 { limit = 20 }
	rows, err := r.pool.Query(ctx, `
		SELECT user_id, reputation::float8,
		       ROW_NUMBER() OVER (ORDER BY reputation DESC, xp DESC)::int,
		       updated_at
		FROM progression_profiles
		ORDER BY reputation DESC, xp DESC
		LIMIT $1
	`, limit)
	if err != nil { return nil, err }
	defer rows.Close()
	result := make([]*domain.InfluenceRank, 0, limit)
	for rows.Next() {
		item := &domain.InfluenceRank{}
		if err := rows.Scan(&item.UserID, &item.Score, &item.Rank, &item.UpdatedAt); err != nil { return nil, err }
		result = append(result, item)
	}
	return result, rows.Err()
}

func (r *PostgresGrowthRepository) ensureProfile(ctx context.Context, tx pgx.Tx, userID string) error {
	_, err := tx.Exec(ctx, `
		INSERT INTO progression_profiles(user_id)
		VALUES($1)
		ON CONFLICT(user_id) DO NOTHING
	`, userID)
	return err
}

func (r *PostgresGrowthRepository) ensureSeason(ctx context.Context, tx pgx.Tx) (string, error) {
	var code string
	if err := tx.QueryRow(ctx, `
		SELECT to_char(current_date,'YYYY') || '-Q' || extract(quarter from current_date)::int
	`).Scan(&code); err != nil { return "", err }
	_, err := tx.Exec(ctx, `
		INSERT INTO progression_seasons(code,name,starts_at,ends_at,active)
		VALUES(
			$1,'Pulse Season '||$1,date_trunc('quarter',NOW()),
			date_trunc('quarter',NOW())+interval '3 months',TRUE
		)
		ON CONFLICT(code) DO UPDATE SET active=TRUE, ends_at=EXCLUDED.ends_at
	`, code)
	return code, err
}

func (r *PostgresGrowthRepository) GetProfile(ctx context.Context, userID string) (*domain.Profile, error) {
	tx, err := r.pool.Begin(ctx)
	if err != nil { return nil, err }
	defer tx.Rollback(ctx)
	if err = r.ensureProfile(ctx, tx, userID); err != nil { return nil, err }
	seasonCode, err := r.ensureSeason(ctx, tx)
	if err != nil { return nil, err }

	p := &domain.Profile{UserID:userID}
	var ignored time.Time
	err = tx.QueryRow(ctx, `
		SELECT xp,level,reputation,
		       LEAST(100,energy+floor(EXTRACT(EPOCH FROM (NOW()-energy_updated_at))/60)::int),
		       current_streak,longest_streak,combo,COALESCE(combo_updated_at,NOW()),
		       boost_until,streak_shields
		FROM progression_profiles WHERE user_id=$1
	`, userID).Scan(
		&p.XP,&p.Level,&p.Reputation,&p.Energy,&p.CurrentStreak,&p.LongestStreak,
		&p.Combo,&ignored,&p.BoostUntil,&p.StreakShields,
	)
	if err != nil { return nil, err }
	p.NextLevelXP=nextLevelXP(p.Level)
	p.ComboMultiplier=comboMultiplier(p.Combo)
	p.BoostActive=p.BoostUntil!=nil && p.BoostUntil.After(time.Now())

	_ = tx.QueryRow(ctx, `
		SELECT COALESCE(xp,0) FROM progression_season_scores
		WHERE season_code=$1 AND user_id=$2
	`, seasonCode,userID).Scan(&p.SeasonXP)
	_ = tx.QueryRow(ctx, `
		SELECT COALESCE(
			(SELECT rank FROM (
				SELECT user_id,ROW_NUMBER() OVER(ORDER BY xp DESC)::int AS rank
				FROM progression_season_scores WHERE season_code=$1
			) ranked WHERE user_id=$2),0)
	`, seasonCode,userID).Scan(&p.SeasonRank)
	if err := tx.Commit(ctx); err != nil { return nil, err }
	return p,nil
}

func (r *PostgresGrowthRepository) RecordEvent(ctx context.Context, userID, action, sourceID string) (*domain.EventResult,error) {
	tx,err:=r.pool.Begin(ctx); if err!=nil{return nil,err}; defer tx.Rollback(ctx)
	if err=r.ensureProfile(ctx,tx,userID);err!=nil{return nil,err}
	seasonCode,err:=r.ensureSeason(ctx,tx);if err!=nil{return nil,err}

	baseXP:=map[string]int64{
		"daily_login":20,"post_created":50,"comment_created":15,"reaction_added":5,
		"message_sent":5,"content_viewed":2,"story_viewed":2,"follow_created":10,
		"story_created":20,"community_joined":25,"community_event_rsvp":15,
		"referral_completed":100,
	}[action]
	if baseXP==0{return nil,fmt.Errorf("unsupported progression action")}

	var zero int64
	err=tx.QueryRow(ctx, `
		INSERT INTO progression_events(user_id,action,source_id)
		VALUES($1,$2,$3)
		ON CONFLICT(user_id,action,source_id) DO NOTHING
		RETURNING 0
	`,userID,action,sourceID).Scan(&zero)
	if err==pgx.ErrNoRows {
		var xp int64; var level,streak,combo int
		_ = tx.QueryRow(ctx,` SELECT xp,level,current_streak,combo FROM progression_profiles WHERE user_id=$1 `,userID).Scan(&xp,&level,&streak,&combo)
		return &domain.EventResult{Applied:false,XP:xp,Level:level,CurrentStreak:streak,Combo:combo},tx.Commit(ctx)
	}
	if err!=nil{return nil,err}

	var xp,reputation int64
	var level,streak,longest,combo,energy int
	var lastDate *time.Time
	var comboAt,boostUntil *time.Time
	err=tx.QueryRow(ctx,`
		SELECT xp,level,reputation,current_streak,longest_streak,combo,energy,
		       last_activity_date,combo_updated_at,boost_until
		FROM progression_profiles WHERE user_id=$1 FOR UPDATE
	`,userID).Scan(&xp,&level,&reputation,&streak,&longest,&combo,&energy,&lastDate,&comboAt,&boostUntil)
	if err!=nil{return nil,err}

	now:=time.Now()
	today:=now.UTC().Truncate(24*time.Hour)
	if lastDate==nil {streak=1} else {
		last:=lastDate.UTC().Truncate(24*time.Hour)
		days:=int(today.Sub(last).Hours()/24)
		if days==1 {streak++} else if days>1 {streak=1}
	}
	if streak>longest {longest=streak}
	if comboAt!=nil && now.Sub(*comboAt)<=5*time.Minute {combo++} else {combo=1}
	mult:=comboMultiplier(combo)
	if boostUntil!=nil && boostUntil.After(now){mult*=2}
	if mult>4{mult=4}
	streakBonus:=int64(0)
	if lastDate==nil || !lastDate.UTC().Truncate(24*time.Hour).Equal(today) {streakBonus=int64(min(streak,20))}
	awarded:=int64(math.Round(float64(baseXP)*mult))+streakBonus
	xp+=awarded; reputation+=awarded/10
	oldLevel:=level; level=nextLevel(xp)

	_,err=tx.Exec(ctx,`
		UPDATE progression_profiles
		SET xp=$2,level=$3,reputation=$4,
		    energy=LEAST(100,energy+floor(EXTRACT(EPOCH FROM (NOW()-energy_updated_at))/60)::int),
		    energy_updated_at=NOW(),current_streak=$5,longest_streak=$6,
		    last_activity_date=CURRENT_DATE,combo=$7,combo_updated_at=NOW(),updated_at=NOW()
		WHERE user_id=$1
	`,userID,xp,level,reputation,streak,longest,combo)
	if err!=nil{return nil,err}

	_,err=tx.Exec(ctx,`
		UPDATE progression_events SET xp_awarded=$4,multiplier=$5
		WHERE user_id=$1 AND action=$2 AND source_id=$3
	`,userID,action,sourceID,awarded,mult)
	if err!=nil{return nil,err}

	_,err=tx.Exec(ctx,`
		INSERT INTO progression_season_scores(season_code,user_id,xp)
		VALUES($1,$2,$3)
		ON CONFLICT(season_code,user_id) DO UPDATE
		SET xp=progression_season_scores.xp+EXCLUDED.xp,updated_at=NOW()
	`,seasonCode,userID,awarded)
	if err!=nil{return nil,err}

	_,err=tx.Exec(ctx,`
		INSERT INTO progression_user_quests(user_id,quest_id,period_start)
		SELECT $1,q.id,CASE WHEN q.cadence='daily' THEN CURRENT_DATE
			ELSE date_trunc('week',CURRENT_DATE)::date END
		FROM progression_quests q WHERE q.active AND q.action=$2
		ON CONFLICT(user_id,quest_id,period_start) DO NOTHING
	`,userID,action)
	if err!=nil{return nil,err}
	_,err=tx.Exec(ctx,`
		UPDATE progression_user_quests uq
		SET progress=LEAST(q.target,uq.progress+1),
		    completed_at=CASE WHEN LEAST(q.target,uq.progress+1)>=q.target
		      THEN COALESCE(uq.completed_at,NOW()) ELSE uq.completed_at END
		FROM progression_quests q
		WHERE uq.quest_id=q.id AND uq.user_id=$1 AND q.action=$2
		  AND uq.period_start IN(CURRENT_DATE,date_trunc('week',CURRENT_DATE)::date)
	`,userID,action)
	if err!=nil{return nil,err}

	questsProgress:=0
	_ = tx.QueryRow(ctx,`
		SELECT COALESCE(MAX(progress),0)
		FROM progression_user_quests uq JOIN progression_quests q ON q.id=uq.quest_id
		WHERE uq.user_id=$1 AND q.action=$2
		  AND uq.period_start IN(CURRENT_DATE,date_trunc('week',CURRENT_DATE)::date)
	`,userID,action).Scan(&questsProgress)

	achievements,err:=unlockAchievements(ctx,tx,userID,action,streak,level)
	if err!=nil{return nil,err}

	_,err=tx.Exec(ctx,`
		UPDATE progression_profiles
		SET streak_shields=LEAST(3,streak_shields+
			CASE WHEN current_streak IN(7,30) THEN 1 ELSE 0 END)
		WHERE user_id=$1
	`,userID)
	if err!=nil{return nil,err}

	result:=&domain.EventResult{
		Applied:true,XP:xp,XPGranted:awarded,Multiplier:mult,Level:level,
		LevelUp:level>oldLevel,CurrentStreak:streak,Combo:combo,
		QuestProgress:questsProgress,Achievements:achievements,
	}
	return result,tx.Commit(ctx)
}

func (r *PostgresGrowthRepository) ListQuests(ctx context.Context,userID,cadence string)([]*domain.Quest,error){
	tx,err:=r.pool.Begin(ctx);if err!=nil{return nil,err};defer tx.Rollback(ctx)
	if err=r.ensureProfile(ctx,tx,userID);err!=nil{return nil,err}
	args:=[]any{userID};where:="q.active";if cadence!="all"{where+=" AND q.cadence=$2";args=append(args,cadence)}
	_,err=tx.Exec(ctx,fmt.Sprintf(`
		INSERT INTO progression_user_quests(user_id,quest_id,period_start)
		SELECT $1,q.id,CASE WHEN q.cadence='daily' THEN CURRENT_DATE
			ELSE date_trunc('week',CURRENT_DATE)::date END
		FROM progression_quests q WHERE %s
		ON CONFLICT(user_id,quest_id,period_start) DO NOTHING
	`,where),args...);if err!=nil{return nil,err}
	query:="SELECT q.id,q.code,q.title,q.description,q.action,q.target,q.xp_reward,q.reputation_reward,q.cadence,COALESCE(uq.progress,0),COALESCE(uq.claimed,FALSE),COALESCE(uq.progress,0)>=q.target FROM progression_quests q LEFT JOIN progression_user_quests uq ON uq.quest_id=q.id AND uq.user_id=$1 AND uq.period_start=CASE WHEN q.cadence='daily' THEN CURRENT_DATE ELSE date_trunc('week',CURRENT_DATE)::date END WHERE "+where
	rows,err:=tx.Query(ctx,query,args...);if err!=nil{return nil,err};defer rows.Close()
	out:=make([]*domain.Quest,0)
	for rows.Next(){q:=&domain.Quest{};if err:=rows.Scan(&q.ID,&q.Code,&q.Title,&q.Description,&q.Action,&q.Target,&q.XPReward,&q.ReputationReward,&q.Cadence,&q.Progress,&q.Claimed,&q.Completed);err!=nil{return nil,err};out=append(out,q)}
	if err:=rows.Err();err!=nil{return nil,err};return out,tx.Commit(ctx)
}

func (r *PostgresGrowthRepository) ClaimQuest(ctx context.Context,userID,questID string)(*domain.Quest,error){
	qid,err:=uuid.Parse(questID);if err!=nil{return nil,fmt.Errorf("invalid quest id")}
	tx,err:=r.pool.Begin(ctx);if err!=nil{return nil,err};defer tx.Rollback(ctx)
	var q domain.Quest;var start time.Time
	err=tx.QueryRow(ctx,`
		SELECT q.id,q.code,q.title,q.description,q.action,q.target,q.xp_reward,q.reputation_reward,q.cadence,
		       COALESCE(uq.progress,0),COALESCE(uq.claimed,FALSE),COALESCE(uq.progress,0)>=q.target,
		       CASE WHEN q.cadence='daily' THEN CURRENT_DATE ELSE date_trunc('week',CURRENT_DATE)::date END
		FROM progression_quests q
		LEFT JOIN progression_user_quests uq ON uq.quest_id=q.id AND uq.user_id=$2
		  AND uq.period_start=CASE WHEN q.cadence='daily' THEN CURRENT_DATE ELSE date_trunc('week',CURRENT_DATE)::date END
		WHERE q.id=$1 AND q.active
	`,qid,userID).Scan(&q.ID,&q.Code,&q.Title,&q.Description,&q.Action,&q.Target,&q.XPReward,&q.ReputationReward,&q.Cadence,&q.Progress,&q.Claimed,&q.Completed,&start)
	if err!=nil{if err==pgx.ErrNoRows{return nil,fmt.Errorf("quest not found")};return nil,err}
	if q.Claimed{return nil,fmt.Errorf("quest already claimed")};if !q.Completed{return nil,fmt.Errorf("quest is not complete")}
	_,err=tx.Exec(ctx,`
		INSERT INTO progression_user_quests(user_id,quest_id,period_start,progress,claimed,completed_at)
		VALUES($1,$2,$3,$4,TRUE,NOW())
		ON CONFLICT(user_id,quest_id,period_start) DO UPDATE
		SET claimed=TRUE,completed_at=NOW()
	`,userID,qid,start,q.Progress);if err!=nil{return nil,err}
	var currentXP int64;var currentLevel int
	_ = tx.QueryRow(ctx,`SELECT xp,level FROM progression_profiles WHERE user_id=$1 FOR UPDATE`,userID).Scan(&currentXP,&currentLevel)
	currentXP+=q.XPReward;currentLevel=nextLevel(currentXP)
	_,err=tx.Exec(ctx,`UPDATE progression_profiles SET xp=$2,level=$3,reputation=reputation+$4,updated_at=NOW() WHERE user_id=$1`,userID,currentXP,currentLevel,q.ReputationReward);if err!=nil{return nil,err}
	q.Claimed=true
	return &q,tx.Commit(ctx)
}

func (r *PostgresGrowthRepository) ClaimStreakShield(ctx context.Context,userID string)(*domain.Profile,error){
	tx,err:=r.pool.Begin(ctx);if err!=nil{return nil,err};defer tx.Rollback(ctx)
	if err=r.ensureProfile(ctx,tx,userID);err!=nil{return nil,err}
	var last *time.Time;var streak,shields int
	err=tx.QueryRow(ctx,`SELECT last_activity_date,current_streak,streak_shields FROM progression_profiles WHERE user_id=$1 FOR UPDATE`,userID).Scan(&last,&streak,&shields);if err!=nil{return nil,err}
	if shields<=0{return nil,fmt.Errorf("no streak shield available")}
	if last==nil{return nil,fmt.Errorf("nothing to protect")}
	_,err=tx.Exec(ctx,`UPDATE progression_profiles SET streak_shields=streak_shields-1,last_activity_date=CURRENT_DATE,updated_at=NOW() WHERE user_id=$1`,userID);if err!=nil{return nil,err}
	p:=&domain.Profile{UserID:userID,CurrentStreak:streak-0,StreakShields:shields-1}
	p.NextLevelXP=nextLevelXP(1)
	return p,tx.Commit(ctx)
}

func (r *PostgresGrowthRepository) ActivateBoost(ctx context.Context,userID string,energyCost int,duration time.Duration)(*domain.Profile,error){
	tx,err:=r.pool.Begin(ctx);if err!=nil{return nil,err};defer tx.Rollback(ctx)
	if err=r.ensureProfile(ctx,tx,userID);err!=nil{return nil,err}
	tag,err:=tx.Exec(ctx,`
		UPDATE progression_profiles
		SET energy=energy-$2,
		    boost_until=GREATEST(COALESCE(boost_until,NOW()),NOW()+($3 || ' minutes')::interval),
		    updated_at=NOW()
		WHERE user_id=$1 AND energy>=$2
		  AND (boost_until IS NULL OR boost_until<=NOW())
	`,userID,energyCost,int(duration.Minutes()));if err!=nil{return nil,err}
	if tag.RowsAffected()==0{return nil,fmt.Errorf("not enough energy or boost already active")}
	return r.profileForTx(ctx,tx,userID)
}

func (r *PostgresGrowthRepository) profileForTx(ctx context.Context,tx pgx.Tx,userID string)(*domain.Profile,error){
	p:=&domain.Profile{UserID:userID}
	err:=tx.QueryRow(ctx,`SELECT xp,level,reputation,energy,current_streak,longest_streak,combo,boost_until,streak_shields FROM progression_profiles WHERE user_id=$1`,userID).Scan(&p.XP,&p.Level,&p.Reputation,&p.Energy,&p.CurrentStreak,&p.LongestStreak,&p.Combo,&p.BoostUntil,&p.StreakShields);if err!=nil{return nil,err}
	p.NextLevelXP=nextLevelXP(p.Level);p.ComboMultiplier=comboMultiplier(p.Combo);p.BoostActive=p.BoostUntil!=nil&&p.BoostUntil.After(time.Now());return p,nil
}

func (r *PostgresGrowthRepository) ListAchievements(ctx context.Context,userID string)([]*domain.Achievement,error){
	rows,err:=r.pool.Query(ctx,`
		SELECT a.id,a.code,a.name,a.description,a.icon,a.xp_reward,a.reputation_reward,ua.unlocked_at
		FROM progression_achievements a
		LEFT JOIN progression_user_achievements ua ON ua.achievement_id=a.id AND ua.user_id=$1
		WHERE a.active ORDER BY ua.unlocked_at DESC NULLS LAST,a.code
	`,userID);if err!=nil{return nil,err};defer rows.Close()
	out:=make([]*domain.Achievement,0)
	for rows.Next(){a:=&domain.Achievement{};if err:=rows.Scan(&a.ID,&a.Code,&a.Name,&a.Description,&a.Icon,&a.XPReward,&a.ReputationReward,&a.UnlockedAt);err!=nil{return nil,err};a.Unlocked=a.UnlockedAt!=nil;out=append(out,a)}
	return out,rows.Err()
}

func (r *PostgresGrowthRepository) GetSeasonLeaderboard(ctx context.Context,userID string,limit int)([]*domain.LeaderboardEntry,error){
	if limit<=0||limit>100{limit=50}
	code:=fmt.Sprintf("%d-Q%d",time.Now().Year(),(int(time.Now().Month())-1)/3+1)
	rows,err:=r.pool.Query(ctx,`
		SELECT ROW_NUMBER() OVER(ORDER BY xp DESC)::int,user_id,xp
		FROM progression_season_scores WHERE season_code=$1
		ORDER BY xp DESC LIMIT $2
	`,code,limit);if err!=nil{return nil,err};defer rows.Close()
	out:=make([]*domain.LeaderboardEntry,0,limit)
	for rows.Next(){e:=&domain.LeaderboardEntry{};if err:=rows.Scan(&e.Rank,&e.UserID,&e.XP);err!=nil{return nil,err};out=append(out,e)}
	return out,rows.Err()
}

func unlockAchievements(ctx context.Context, tx pgx.Tx, userID, action string, streak, level int) ([]domain.Achievement, error) {
	rows, err := tx.Query(ctx, `
		SELECT a.id,a.code,a.name,a.description,a.icon,a.xp_reward,a.reputation_reward
		FROM progression_achievements a
		WHERE a.active
		  AND NOT EXISTS (
		    SELECT 1 FROM progression_user_achievements ua
		    WHERE ua.user_id=$1 AND ua.achievement_id=a.id
		  )
		  AND (
		    (a.metric=$2 AND (SELECT COUNT(*) FROM progression_events e WHERE e.user_id=$1 AND e.action=a.metric)>=a.threshold)
		    OR (a.metric='streak' AND $3>=a.threshold)
		    OR (a.metric='level' AND $4>=a.threshold)
		  )
	`, userID, action, streak, level)
	if err != nil { return nil, err }
	defer rows.Close()

	out := make([]domain.Achievement, 0)
	for rows.Next() {
		var a domain.Achievement
		if err := rows.Scan(&a.ID,&a.Code,&a.Name,&a.Description,&a.Icon,&a.XPReward,&a.ReputationReward); err != nil {
			return nil, err
		}
		if _, err := tx.Exec(ctx, `INSERT INTO progression_user_achievements(user_id,achievement_id) VALUES($1,$2) ON CONFLICT DO NOTHING`, userID, a.ID); err != nil {
			return nil, err
		}
		var currentXP int64
		if err := tx.QueryRow(ctx, `SELECT xp FROM progression_profiles WHERE user_id=$1 FOR UPDATE`, userID).Scan(&currentXP); err != nil {
			return nil, err
		}
		currentXP += a.XPReward
		if _, err := tx.Exec(ctx, `UPDATE progression_profiles SET xp=$2,level=$3,reputation=reputation+$4,updated_at=NOW() WHERE user_id=$1`, userID, currentXP, nextLevel(currentXP), a.ReputationReward); err != nil {
			return nil, err
		}
		a.Unlocked = true
		out = append(out, a)
	}
	return out, rows.Err()
}

func nextLevel(xp int64) int { if xp<=0{return 1}; return int(math.Floor(math.Sqrt(float64(xp)/100)))+1 }
func nextLevelXP(level int) int64 { if level<1{level=1}; return int64(level*level)*100 }
func comboMultiplier(combo int) float64 { if combo<=1{return 1}; m:=1+float64(min(combo-1,10))*0.1;if m>2{m=2};return m }
func min(a,b int) int { if a<b{return a};return b }
