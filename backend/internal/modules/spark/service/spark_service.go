package service

import (
	"context"

	"local/merope/internal/modules/spark/domain"
)

type sparkService struct {
	repo domain.SparkRepository
}

func NewSparkService(repo domain.SparkRepository) domain.SparkService {
	return &sparkService{repo: repo}
}

func (s *sparkService) FindMatch(ctx context.Context, userID string) (*domain.Match, error) {
	return s.repo.FindMatch(ctx, userID)
}

func (s *sparkService) GetResonanceScore(ctx context.Context, userAID, userBID string) float64 {
	score, _ := s.repo.GetResonanceScore(ctx, userAID, userBID)
	return score
}
