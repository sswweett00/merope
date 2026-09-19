package infra

import (
	"context"
	"errors"
	"fmt"
	"time"

	"local/merope/internal/platform/scylla"
	"local/merope/internal/modules/content/domain"

	"github.com/google/uuid"
)

type ScyllaContentRepository struct {
	client *scylla.Client
}

func NewScyllaContentRepository(client *scylla.Client) *ScyllaContentRepository {
	return &ScyllaContentRepository{client: client}
}

func (r *ScyllaContentRepository) CreateSignal(ctx context.Context, signal *domain.Signal) error {
	return errors.New("signal creation uses PostgreSQL as source of truth")
}

func (r *ScyllaContentRepository) GetStream(ctx context.Context, userID string, limit, offset int32) ([]*domain.Signal, error) {
	return nil, errors.New("timeline feed uses user_timeline table via Social repository")
}

func (r *ScyllaContentRepository) AddResonance(ctx context.Context, userID, signalID string, amplitude int) error {
	return r.toggleReaction(ctx, signalID, userID, "resonance", true)
}

func (r *ScyllaContentRepository) RemoveResonance(ctx context.Context, userID, signalID string) error {
	return r.toggleReaction(ctx, signalID, userID, "resonance", false)
}

func (r *ScyllaContentRepository) UpdateSignalStatus(ctx context.Context, signalID string, pinned, archived, draft bool) error {
	sid, err := uuid.Parse(signalID)
	if err != nil {
		return fmt.Errorf("invalid signal_id: %w", err)
	}
	return r.client.Exec(ctx,
		`UPDATE signal_by_id SET is_pinned = ?, is_archived = ?, is_draft = ? WHERE signal_id = ?`,
		pinned, archived, draft, sid,
	)
}

func (r *ScyllaContentRepository) CreateMentions(ctx context.Context, mentions []*domain.Mention) error {
	return nil
}

func (r *ScyllaContentRepository) CreateNode(ctx context.Context, signalID, authorID string, parentID *string, content string) (*domain.Node, error) {
	signalUUID, err := uuid.Parse(signalID)
	if err != nil {
		return nil, fmt.Errorf("invalid signal_id: %w", err)
	}
	authorUUID, err := uuid.Parse(authorID)
	if err != nil {
		return nil, fmt.Errorf("invalid author_id: %w", err)
	}

	nodeID := uuid.New()
	now := time.Now().UnixMilli()
	level := 0

	var parentUUID *uuid.UUID
	if parentID != nil && *parentID != "" {
		parsed, err := uuid.Parse(*parentID)
		if err == nil {
			parentUUID = &parsed
			level = 1
		}
	}

	err = r.client.Exec(ctx,
		`INSERT INTO signal_comments_by_signal (signal_id, created_at, node_id, author_id, content, parent_id, level)
		 VALUES (?, ?, ?, ?, ?, ?, ?)`,
		signalUUID, now, nodeID, authorUUID, content, parentUUID, level,
	)
	if err != nil {
		return nil, fmt.Errorf("failed to write comment to ScyllaDB: %w", err)
	}

	return &domain.Node{
		ID:       nodeID.String(),
		SignalID: signalID,
		AuthorID: authorID,
		ParentID: parentID,
		Content:  content,
		CreatedAt: time.UnixMilli(now),
	}, nil
}

func (r *ScyllaContentRepository) GetNodesForSignal(ctx context.Context, signalID string) ([]*domain.Node, error) {
	signalUUID, err := uuid.Parse(signalID)
	if err != nil {
		return nil, fmt.Errorf("invalid signal_id: %w", err)
	}

	q := r.client.Session.Query(
		`SELECT signal_id, created_at, node_id, author_id, parent_id, content, level
		 FROM signal_comments_by_signal
		 WHERE signal_id = ? LIMIT 100`,
		signalUUID,
	).WithContext(ctx).Iter()

	var sid uuid.UUID
	var createdAt int64
	var nodeID, authorID, parentID uuid.UUID
	var content string
	var level int
	nodes := make([]*domain.Node, 0, 50)

	for q.Scan(&sid, &createdAt, &nodeID, &authorID, &parentID, &content, &level) {
		var pid *string
		if !isUUIDZero(parentID) {
			s := parentID.String()
			pid = &s
		}
		nodes = append(nodes, &domain.Node{
			ID:       nodeID.String(),
			SignalID: sid.String(),
			AuthorID: authorID.String(),
			ParentID: pid,
			Content:  content,
			CreatedAt: time.UnixMilli(createdAt),
		})
	}

	if err := q.Close(); err != nil {
		return nil, fmt.Errorf("failed to read comments: %w", err)
	}
	return nodes, nil
}

func isUUIDZero(id uuid.UUID) bool {
	var zero uuid.UUID
	return id == zero
}

func (r *ScyllaContentRepository) CreateWavePool(ctx context.Context, signalID, question string, endsAt time.Time, options []string) error {
	return nil
}

func (r *ScyllaContentRepository) VoteWave(ctx context.Context, poolID, optionID, userID string) error {
	return nil
}

func (r *ScyllaContentRepository) GetWaveResults(ctx context.Context, poolID string) (map[string]int, error) {
	return nil, nil
}

func (r *ScyllaContentRepository) LinkFrequencies(ctx context.Context, signalID string, tags []string) error {
	return nil
}

func (r *ScyllaContentRepository) CreateVault(ctx context.Context, ownerID, name string, isPrivate bool) (string, error) {
	return "", nil
}

func (r *ScyllaContentRepository) VaultSignal(ctx context.Context, userID, signalID string, vaultID *string) error {
	return nil
}

func (r *ScyllaContentRepository) toggleReaction(ctx context.Context, targetID, userID, reactionType string, add bool) error {
	targetUUID, err := uuid.Parse(targetID)
	if err != nil {
		return fmt.Errorf("invalid target_id: %w", err)
	}
	userUUID, err := uuid.Parse(userID)
	if err != nil {
		return fmt.Errorf("invalid user_id: %w", err)
	}

	if add {
		now := time.Now().UnixMilli()
		return r.client.Exec(ctx,
			`UPDATE reactions_by_target SET created_at = ? WHERE target_id = ? AND reaction_type = ? AND user_id = ?`,
			now, targetUUID, reactionType, userUUID,
		)
	}
	return r.client.Exec(ctx,
		`DELETE FROM reactions_by_target WHERE target_id = ? AND reaction_type = ? AND user_id = ?`,
		targetUUID, reactionType, userUUID,
	)
}
