package transport

import (
	"local/merope/internal/modules/talent/domain"

	"github.com/gofiber/fiber/v2"
)

type TalentHandler struct {
	service domain.TalentService
}

func NewTalentHandler(service domain.TalentService) *TalentHandler {
	return &TalentHandler{service: service}
}

func (h *TalentHandler) PostJob(c *fiber.Ctx) error {
	companyID := c.Locals("user_id").(string)

	var req struct {
		Title       string `json:"title"`
		Description string `json:"description"`
		Location    string `json:"location"`
		JobType     string `json:"job_type"`
	}

	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}

	job, err := h.service.PostJob(c.Context(), companyID, req.Title, req.Description, req.Location, req.JobType)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"job":      job,
		"job_id":   job.ID,
		"title":    job.Title,
	})
}

func (h *TalentHandler) ApplyToJob(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	jobID := c.Params("id")

	var req struct {
		ResumeURL   string `json:"resume_url"`
		CoverLetter string `json:"cover_letter"`
	}

	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}

	app, err := h.service.ApplyToJob(c.Context(), userID, jobID, req.ResumeURL, req.CoverLetter)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"application": app,
		"application_id": app.ID,
	})
}