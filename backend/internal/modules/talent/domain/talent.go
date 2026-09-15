package domain

import (
	"context"
	"time"
)

type Job struct {
	ID           string
	CompanyID    string
	Title        string
	Description  string
	Location     string
	JobType      string
	SalaryRange  string
	Requirements []string
	IsActive     bool
	CreatedAt    time.Time
}

type JobApplication struct {
	ID          string
	JobID       string
	ApplicantID string
	ResumeURL   string
	CoverLetter string
	Status      string
	CreatedAt   time.Time
}

type ProfessionalProfile struct {
	UserID       string
	Headline     string
	About        string
	Pathways     []Experience
	Vibrations   []string // Skills
	Amplifications []string // Certifications
	UpdatedAt    time.Time
}

type Experience struct {
	Title       string
	Company     string
	Location    string
	StartDate   time.Time
	EndDate     *time.Time
	Description string
}

type TalentRepository interface {
	CreateJob(ctx context.Context, j *Job) error
	GetJobs(ctx context.Context) ([]*Job, error)
	Apply(ctx context.Context, app *JobApplication) error
	GetProfile(ctx context.Context, userID string) (*ProfessionalProfile, error)
	UpdateProfile(ctx context.Context, profile *ProfessionalProfile) error
}

type TalentService interface {
	PostJob(ctx context.Context, companyID string, title, desc, loc, jType string) (*Job, error)
	ApplyToJob(ctx context.Context, applicantID, jobID, resume, cover string) (*JobApplication, error)
	UpdateProfessionalProfile(ctx context.Context, profile *ProfessionalProfile) error
	GetProfessionalProfile(ctx context.Context, userID string) (*ProfessionalProfile, error)
}
