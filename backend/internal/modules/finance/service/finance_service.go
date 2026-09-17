package service

import (
	"context"
	"fmt"

	"local/merope/internal/modules/content/domain"
	financeDomain "local/merope/internal/modules/finance/domain"
)

type financeService struct {
	repo        financeDomain.RuntimeFinanceRepository
	contentRepo domain.ContentRepository
}

func NewFinanceService(repo financeDomain.RuntimeFinanceRepository, contentRepo domain.ContentRepository) financeDomain.RuntimeFinanceService {
	return &financeService{repo: repo, contentRepo: contentRepo}
}

func (s *financeService) TipUser(ctx context.Context, senderID, receiverID string, amount int64) error {
	if amount <= 0 {
		return fmt.Errorf("amount must be positive")
	}
	return s.repo.Transfer(ctx, senderID, receiverID, amount, "tip", nil, nil)
}

func (s *financeService) UnlockContent(ctx context.Context, userID, postID string, amount int64) error {
	if amount <= 0 {
		return fmt.Errorf("amount must be positive")
	}

	signal, err := s.contentRepo.GetSignalByID(ctx, postID)
	if err != nil {
		return fmt.Errorf("failed to fetch post: %w", err)
	}
	if signal == nil {
		return fmt.Errorf("post not found")
	}

	return s.repo.Transfer(ctx, userID, signal.AuthorID, amount, "unlock", nil, &postID)
}

func (s *financeService) GetBalance(ctx context.Context, userID string) (int64, error) {
	w, err := s.repo.GetWallet(ctx, userID)
	if err != nil {
		return 0, err
	}
	return w.Balance, nil
}

func (s *financeService) InitiateEscrow(ctx context.Context, buyerID, sellerID string, amount int64, description string) (*financeDomain.EscrowRecord, error) {
	if amount <= 0 {
		return nil, fmt.Errorf("amount must be positive")
	}
	w, err := s.repo.GetWallet(ctx, buyerID)
	if err != nil {
		return nil, err
	}
	if w.Balance < amount {
		return nil, fmt.Errorf("insufficient balance")
	}

	escrow := &financeDomain.EscrowRecord{
		BuyerID:     buyerID,
		SellerID:    sellerID,
		Amount:      amount,
		Status:      "held",
		Description: description,
	}
	if err := s.repo.CreateEscrow(ctx, escrow); err != nil {
		return nil, err
	}
	return escrow, nil
}

func (s *financeService) ReleaseEscrow(ctx context.Context, escrowID, userID string) error {
	escrow, err := s.repo.GetEscrow(ctx, escrowID)
	if err != nil {
		return err
	}
	if escrow.BuyerID != userID {
		return fmt.Errorf("only buyer can release escrow")
	}
	if err := s.repo.Transfer(ctx, escrow.BuyerID, escrow.SellerID, escrow.Amount, "escrow_release", nil, &escrow.ID); err != nil {
		return err
	}
	return s.repo.UpdateEscrowStatus(ctx, escrowID, "released")
}

func (s *financeService) RefundEscrow(ctx context.Context, escrowID, userID string) error {
	escrow, err := s.repo.GetEscrow(ctx, escrowID)
	if err != nil {
		return err
	}
	if escrow.SellerID != userID {
		return fmt.Errorf("only seller can refund")
	}
	return s.repo.UpdateEscrowStatus(ctx, escrowID, "refunded")
}
