-- Merope Progression Engine: XP, levels, streaks, quests, achievements, seasons,
-- energy, combo multipliers and temporary XP boosts.
CREATE TABLE IF NOT EXISTS progression_profiles (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    xp BIGINT NOT NULL DEFAULT 0,
    level INTEGER NOT NULL DEFAULT 1,
    reputation BIGINT NOT NULL DEFAULT 0,
    energy INTEGER NOT NULL DEFAULT 100 CHECK (energy BETWEEN 0 AND 100),
    energy_updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    current_streak INTEGER NOT NULL DEFAULT 0,
    longest_streak INTEGER NOT NULL DEFAULT 0,
    last_activity_date DATE,
    combo INTEGER NOT NULL DEFAULT 0,
    combo_updated_at TIMESTAMPTZ,
    streak_shields INTEGER NOT NULL DEFAULT 1,
    boost_until TIMESTAMPTZ,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS progression_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    action TEXT NOT NULL,
    source_id TEXT NOT NULL,
    xp_awarded BIGINT NOT NULL DEFAULT 0,
    multiplier NUMERIC(6,3) NOT NULL DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, action, source_id)
);
CREATE INDEX IF NOT EXISTS idx_progression_events_user_time
    ON progression_events(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_progression_events_action_time
    ON progression_events(action, created_at DESC);

CREATE TABLE IF NOT EXISTS progression_quests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    action TEXT NOT NULL,
    target INTEGER NOT NULL CHECK (target > 0),
    xp_reward BIGINT NOT NULL DEFAULT 0,
    reputation_reward BIGINT NOT NULL DEFAULT 0,
    cadence TEXT NOT NULL CHECK (cadence IN ('daily', 'weekly')),
    active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS progression_user_quests (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    quest_id UUID NOT NULL REFERENCES progression_quests(id) ON DELETE CASCADE,
    period_start DATE NOT NULL,
    progress INTEGER NOT NULL DEFAULT 0,
    claimed BOOLEAN NOT NULL DEFAULT FALSE,
    completed_at TIMESTAMPTZ,
    PRIMARY KEY(user_id, quest_id, period_start)
);
CREATE INDEX IF NOT EXISTS idx_progression_user_quests_user
    ON progression_user_quests(user_id, period_start DESC);

CREATE TABLE IF NOT EXISTS progression_achievements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    icon TEXT NOT NULL DEFAULT 'star',
    metric TEXT NOT NULL,
    threshold BIGINT NOT NULL CHECK (threshold > 0),
    xp_reward BIGINT NOT NULL DEFAULT 0,
    reputation_reward BIGINT NOT NULL DEFAULT 0,
    active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS progression_user_achievements (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    achievement_id UUID NOT NULL REFERENCES progression_achievements(id) ON DELETE CASCADE,
    unlocked_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(user_id, achievement_id)
);

CREATE TABLE IF NOT EXISTS progression_seasons (
    code TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    starts_at TIMESTAMPTZ NOT NULL,
    ends_at TIMESTAMPTZ NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS progression_season_scores (
    season_code TEXT NOT NULL REFERENCES progression_seasons(code) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    xp BIGINT NOT NULL DEFAULT 0,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(season_code, user_id)
);
CREATE INDEX IF NOT EXISTS idx_progression_season_rank
    ON progression_season_scores(season_code, xp DESC);

INSERT INTO progression_quests(code, title, description, action, target, xp_reward, reputation_reward, cadence)
VALUES
('daily_signal', 'Signal', 'Create one original signal.', 'post_created', 1, 80, 4, 'daily'),
('daily_resonance', 'Resonance', 'React to five signals.', 'reaction_added', 5, 60, 3, 'daily'),
('daily_chat', 'Connection', 'Send three messages.', 'message_sent', 3, 50, 2, 'daily'),
('daily_explore', 'Explorer', 'Open five pieces of content.', 'content_viewed', 5, 40, 2, 'daily'),
('daily_circle', 'Circle', 'Follow two people.', 'follow_created', 2, 50, 3, 'daily'),
('weekly_creator', 'Creator Week', 'Publish five signals this week.', 'post_created', 5, 300, 15, 'weekly'),
('weekly_social', 'Social Pulse', 'Send twenty messages this week.', 'message_sent', 20, 220, 10, 'weekly'),
('weekly_resonance', 'Deep Resonance', 'Give fifty reactions this week.', 'reaction_added', 50, 240, 12, 'weekly')
ON CONFLICT (code) DO NOTHING;

INSERT INTO progression_achievements(code, name, description, metric, threshold, xp_reward, reputation_reward, icon)
VALUES
('first_signal', 'First Signal', 'Publish your first signal.', 'post_created', 1, 100, 5, 'bolt'),
('social_butterfly', 'Social Butterfly', 'Send one hundred messages.', 'message_sent', 100, 250, 15, 'forum'),
('resonance_master', 'Resonance Master', 'React to five hundred signals.', 'reaction_added', 500, 500, 25, 'favorite'),
('streak_7', 'Seven Day Pulse', 'Maintain a seven day activity streak.', 'streak', 7, 350, 20, 'local_fire_department'),
('level_10', 'Apex Level', 'Reach level ten.', 'level', 10, 750, 50, 'workspace_premium'),
('community_builder', 'Community Builder', 'Join ten communities.', 'community_joined', 10, 400, 30, 'groups'),
('referral_star', 'Referral Star', 'Complete three successful referrals.', 'referral_completed', 3, 450, 35, 'person_add'),
('creator_50', 'Creator Momentum', 'Publish fifty signals.', 'post_created', 50, 1000, 60, 'auto_awesome')
ON CONFLICT (code) DO NOTHING;


CREATE TABLE IF NOT EXISTS growth_referrals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    referrer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    referred_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    code TEXT NOT NULL DEFAULT '',
    reward_granted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(referrer_id, referred_id)
);
CREATE INDEX IF NOT EXISTS idx_growth_referrals_referrer
    ON growth_referrals(referrer_id, created_at DESC);
