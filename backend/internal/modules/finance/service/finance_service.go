package service

import (
	"context"
	"fmt"
	"local/merope/internal/modules/finance/domain"
	contentDomain "local/merope/internal/modules/content/domain"
)

type financeService struct {
	repo        domain.FinanceRepository
	contentRepo contentDomain.ContentRepository
}

func NewFinanceService(repo domain.FinanceRepository, contentRepo contentDomain.ContentRepository) domain.FinanceService {
	return &financeService{
		repo:        repo,
		contentRepo: contentRepo,
	}
}

func (s *financeService) TipUser(ctx context.Context, senderID, receiverID string, amount int32) error {
	if amount <= 0 {
		return fmt.Errorf("amount must be positive")
	}
	return s.repo.Transfer(ctx, senderID, receiverID, amount, "tip", nil, nil)
}

func (s *financeService) UnlockContent(ctx context.Context, userID, postID string, amount int32) error {
	if amount <= 0 {
		return fmt.Errorf("amount must be positive")
	}

	// Fetch the post author from ContentRepository
	signal, err := s.contentRepo.GetSignalByID(ctx, postID)
	if err != nil {
		return fmt.Errorf("failed to fetch post: %w", err)
	}
	if signal == nil {
		return fmt.Errorf("post not found")
	}

	receiverID := signal.AuthorID

	return s.repo.Transfer(ctx, userID, receiverID, amount, "unlock", nil, &postID)
}

func (s *financeService) GetBalance(ctx context.Context, userID string) (int32, error) {
	w, err := s.repo.GetWallet(ctx, userID)
	if err != nil {
		return 0, err
	}
	return w.Balance, nil
}

func (s *financeService) InitiateEscrow(ctx context.Context, buyerID, sellerID string, amount int32, description string) (*domain.EscrowRecord, error) {
	// 1. Verify buyer has enough balance
	w, err := s.repo.GetWallet(ctx, buyerID)
	if err != nil || w.Balance < amount {
		return nil, fmt.Errorf("insufficient balance")
	}

	// 2. Create escrow record
	escrow := &domain.EscrowRecord{
		BuyerID:     buyerID,
		SellerID:    sellerID,
		Amount:      amount,
		Status:      "held",
		Description: description,
	}
	if err := s.repo.CreateEscrow(ctx, escrow); err != nil {
		return nil, err
	}

	// 3. Subtract from buyer wallet (placeholder logic)
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

	// Transfer to seller
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
	if escrow.SellerID != userID { // In a real system, this would be more complex
		return fmt.Errorf("only seller can refund")
	}

	return s.repo.UpdateEscrowStatus(ctx, escrowID, "refunded")
}
