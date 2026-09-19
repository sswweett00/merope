package infra

import (
	"context"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"

	"local/merope/internal/core/util"
	"local/merope/internal/modules/community/domain"
)

func (r *postgresCommunityRepository) CreateThread(ctx context.Context, t *domain.Thread) error {
	if t == nil {
		return fmt.Errorf("thread is required")
	}
	collectiveID, err := parseUUID(t.CollectiveID)
	if err != nil {
		return err
	}
	authorID, err := parseUUID(t.AuthorID)
	if err != nil {
		return err
	}
	var id pgtype.UUID
	err = r.queries.QueryRow(ctx, `
INSERT INTO threads (id, collective_id, author_id, title, content, resonance, view_count, reply_count, is_pinned, is_locked, is_announcement, tags, category)
VALUES (COALESCE($1, gen_random_uuid()), $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
RETURNING id, created_at, updated_at`,
		uuidOrNull(t.ID), collectiveID, authorID, t.Title, t.Content, t.Resonance, t.ViewCount, t.ReplyCount, t.IsPinned, t.IsLocked, t.IsAnnouncement, t.Tags, t.Category,
	).Scan(&id, &t.CreatedAt, &t.UpdatedAt)
	if err != nil {
		return err
	}
	t.ID = util.UUIDToString(id)
	return nil
}

func (r *postgresCommunityRepository) GetThread(ctx context.Context, threadID string) (*domain.Thread, error) {
	id, err := parseUUID(threadID)
	if err != nil {
		return nil, err
	}
	var t domain.Thread
	var rowID, collectiveID, authorID pgtype.UUID
	err = r.queries.QueryRow(ctx, `
SELECT id, collective_id, author_id, title, content, resonance, view_count, reply_count, is_pinned, is_locked, is_announcement, tags, category, created_at, updated_at
FROM threads WHERE id = $1`, id).Scan(
		&rowID, &collectiveID, &authorID, &t.Title, &t.Content, &t.Resonance, &t.ViewCount, &t.ReplyCount,
		&t.IsPinned, &t.IsLocked, &t.IsAnnouncement, &t.Tags, &t.Category, &t.CreatedAt, &t.UpdatedAt,
	)
	if err != nil {
		return nil, err
	}
	t.ID = util.UUIDToString(rowID)
	t.CollectiveID = util.UUIDToString(collectiveID)
	t.AuthorID = util.UUIDToString(authorID)
	return &t, nil
}

func (r *postgresCommunityRepository) GetThreads(ctx context.Context, collectiveID string, limit, offset int32) ([]*domain.Thread, error) {
	cid, err := parseUUID(collectiveID)
	if err != nil {
		return nil, err
	}
	if limit <= 0 {
		limit = 50
	}
	if offset < 0 {
		offset = 0
	}
	rows, err := r.queries.Query(ctx, `
SELECT id, collective_id, author_id, title, content, resonance, view_count, reply_count, is_pinned, is_locked, is_announcement, tags, category, created_at, updated_at
FROM threads WHERE collective_id = $1 ORDER BY is_pinned DESC, created_at DESC LIMIT $2 OFFSET $3`, cid, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	result := make([]*domain.Thread, 0)
	for rows.Next() {
		var t domain.Thread
		var id, cid, aid pgtype.UUID
		if err := rows.Scan(&id, &cid, &aid, &t.Title, &t.Content, &t.Resonance, &t.ViewCount, &t.ReplyCount, &t.IsPinned, &t.IsLocked, &t.IsAnnouncement, &t.Tags, &t.Category, &t.CreatedAt, &t.UpdatedAt); err != nil {
			return nil, err
		}
		t.ID = util.UUIDToString(id)
		t.CollectiveID = util.UUIDToString(cid)
		t.AuthorID = util.UUIDToString(aid)
		result = append(result, &t)
	}
	return result, rows.Err()
}

func (r *postgresCommunityRepository) UpdateThread(ctx context.Context, threadID string, updates *domain.Thread) error {
	id, err := parseUUID(threadID)
	if err != nil {
		return err
	}
	if updates == nil {
		return fmt.Errorf("thread updates are required")
	}
	_, err = r.queries.Exec(ctx, `UPDATE threads SET title=$2, content=$3, tags=$4, category=$5, is_pinned=$6, is_locked=$7, is_announcement=$8, updated_at=NOW() WHERE id=$1`, id, updates.Title, updates.Content, updates.Tags, updates.Category, updates.IsPinned, updates.IsLocked, updates.IsAnnouncement)
	return err
}

func (r *postgresCommunityRepository) ResonateThread(ctx context.Context, threadID string, delta int) error {
	id, err := parseUUID(threadID)
	if err != nil {
		return err
	}
	_, err = r.queries.Exec(ctx, `UPDATE threads SET resonance = resonance + $2, updated_at = NOW() WHERE id = $1`, id, delta)
	return err
}

func (r *postgresCommunityRepository) GetThreadReplies(ctx context.Context, threadID string, limit, offset int32) ([]*domain.ThreadReply, error) {
	id, err := parseUUID(threadID)
	if err != nil {
		return nil, err
	}
	if limit <= 0 {
		limit = 100
	}
	if offset < 0 {
		offset = 0
	}
	rows, err := r.queries.Query(ctx, `
SELECT id, thread_id, author_id, content, resonance, created_at, updated_at, is_edited, parent_id
FROM thread_replies WHERE thread_id=$1 ORDER BY created_at ASC LIMIT $2 OFFSET $3`, id, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := make([]*domain.ThreadReply, 0)
	for rows.Next() {
		var reply domain.ThreadReply
		var rid, tid, aid pgtype.UUID
		var parent pgtype.UUID
		if err := rows.Scan(&rid, &tid, &aid, &reply.Content, &reply.Resonance, &reply.CreatedAt, &reply.UpdatedAt, &reply.IsEdited, &parent); err != nil {
			return nil, err
		}
		reply.ID = util.UUIDToString(rid)
		reply.ThreadID = util.UUIDToString(tid)
		reply.AuthorID = util.UUIDToString(aid)
		if parent.Valid {
			p := util.UUIDToString(parent)
			reply.ParentID = &p
		}
		out = append(out, &reply)
	}
	return out, rows.Err()
}

func (r *postgresCommunityRepository) PinThread(ctx context.Context, threadID string, pinned bool) error {
	id, err := parseUUID(threadID)
	if err != nil {
		return err
	}
	_, err = r.queries.Exec(ctx, `UPDATE threads SET is_pinned=$2, updated_at=NOW() WHERE id=$1`, id, pinned)
	return err
}
func (r *postgresCommunityRepository) LockThread(ctx context.Context, threadID string, locked bool) error {
	id, err := parseUUID(threadID)
	if err != nil {
		return err
	}
	_, err = r.queries.Exec(ctx, `UPDATE threads SET is_locked=$2, updated_at=NOW() WHERE id=$1`, id, locked)
	return err
}

func parseUUID(value string) (pgtype.UUID, error) {
	var id pgtype.UUID
	if err := id.Scan(strings.TrimSpace(value)); err != nil {
		return id, fmt.Errorf("invalid uuid: %w", err)
	}
	return id, nil
}
func uuidOrNull(value string) interface{} {
	if strings.TrimSpace(value) == "" {
		return nil
	}
	id, err := parseUUID(value)
	if err != nil {
		return nil
	}
	return id
}

var _ domain.CommunityRepository = (*postgresCommunityRepository)(nil)
