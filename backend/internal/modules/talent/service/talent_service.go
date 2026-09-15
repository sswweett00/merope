package service

import (
	"context"
	"fmt"
	"time"

	"local/merope/internal/modules/talent/domain"
)

type talentService struct {
	repo domain.TalentRepository
}

func NewTalentService(repo domain.TalentRepository) domain.TalentService {
	return &talentService{repo: repo}
}

func (s *talentService) PostJob(ctx context.Context, companyID, title, desc, loc, jType string) (*domain.Job, error) {
	if title == "" {
		return nil, fmt.Errorf("job title is required")
	}

	job := &domain.Job{
		CompanyID:   companyID,
		Title:       title,
		Description: desc,
		Location:    loc,
		JobType:     jType,
		IsActive:    true,
		CreatedAt:   time.Now(),
	}

	return job, s.repo.CreateJob(ctx, job)
}

func (s *talentService) ApplyToJob(ctx context.Context, applicantID, jobID, resume, cover string) (*domain.JobApplication, error) {
	if resume == "" {
		return nil, fmt.Errorf("resume URL is required")
	}

	app := &domain.JobApplication{
		JobID:       jobID,
		ApplicantID: applicantID,
		ResumeURL:   resume,
		CoverLetter: cover,
		Status:      "pending",
		CreatedAt:   time.Now(),
	}

	return app, s.repo.Apply(ctx, app)
}

func (s *talentService) UpdateProfessionalProfile(ctx context.Context, profile *domain.ProfessionalProfile) error {
	profile.UpdatedAt = time.Now()
	return s.repo.UpdateProfile(ctx, profile)
}

func (s *talentService) GetProfessionalProfile(ctx context.Context, userID string) (*domain.ProfessionalProfile, error) {
	return s.repo.GetProfile(ctx, userID)
}
