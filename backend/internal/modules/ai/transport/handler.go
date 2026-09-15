package transport

import (
	"strconv"
	"strings"
	"time"

	"local/merope/internal/core/observability"
	"local/merope/internal/modules/ai/domain"

	"github.com/gofiber/fiber/v2"
)

type AIHandler struct {
	service domain.AIService
}

func NewAIHandler(service domain.AIService) *AIHandler {
	return &AIHandler{service: service}
}

func (h *AIHandler) AnalyzeContent(c *fiber.Ctx) error {
	ctx, span := observability.StartSpan(c.Context(), "AIHandler.AnalyzeContent")
	defer span.End()

	type request struct {
		TargetID    string `json:"target_id"`
		ContentType string `json:"content_type"`
		Text        string `json:"text"`
		MediaURL    string `json:"media_url"`
	}

	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}

	if req.TargetID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "target_id is required"})
	}

	analysis, err := h.service.AnalyzeContent(ctx, req.TargetID, req.ContentType, req.Text, req.MediaURL)
	if err != nil {
		span.RecordError(err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.Status(fiber.StatusCreated).JSON(analysis)
}

func (h *AIHandler) AnalyzeBatch(c *fiber.Ctx) error {
	ctx, span := observability.StartSpan(c.Context(), "AIHandler.AnalyzeBatch")
	defer span.End()

	type taskRequest struct {
		TargetID    string `json:"target_id"`
		ContentType string `json:"content_type"`
		Text        string `json:"text"`
		MediaURL    string `json:"media_url"`
	}

	type batchRequest struct {
		Tasks []taskRequest `json:"tasks"`
	}

	var req batchRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}

	if len(req.Tasks) == 0 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "at least one task is required"})
	}

	tasks := make([]domain.ContentTask, 0, len(req.Tasks))
	for _, t := range req.Tasks {
		tasks = append(tasks, domain.ContentTask{
			TargetID:    t.TargetID,
			ContentType: t.ContentType,
			Text:        t.Text,
			MediaURL:    t.MediaURL,
		})
	}

	results, err := h.service.AnalyzeBatch(ctx, tasks)
	if err != nil {
		span.RecordError(err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{"analyses": results, "count": len(results)})
}

func (h *AIHandler) GetRecommendations(c *fiber.Ctx) error {
	ctx, span := observability.StartSpan(c.Context(), "AIHandler.GetRecommendations")
	defer span.End()

	userID := c.Query("user_id")
	if userID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "user_id query param is required"})
	}

	limit := 20
	if limitStr := c.Query("limit"); limitStr != "" {
		if parsed, err := strconv.Atoi(limitStr); err == nil && parsed > 0 {
			limit = parsed
		}
	}

	contentType := c.Query("content_type", "")
	excludeIDsStr := c.Query("exclude_ids", "")
	var excludeIDs []string
	if excludeIDsStr != "" {
		excludeIDs = strings.Split(excludeIDsStr, ",")
	}

	req := &domain.RecommendationRequest{
		UserID:      userID,
		Limit:       limit,
		ContentType: contentType,
		ExcludeIDs:  excludeIDs,
	}

	resp, err := h.service.GetRecommendations(ctx, req)
	if err != nil {
		span.RecordError(err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(resp)
}

func (h *AIHandler) GetTrending(c *fiber.Ctx) error {
	ctx, span := observability.StartSpan(c.Context(), "AIHandler.GetTrending")
	defer span.End()

	windowStr := c.Query("window", "24h")
	window, err := time.ParseDuration(windowStr)
	if err != nil {
		window = 24 * time.Hour
	}

	topics, err := h.service.GetTrendingTopics(ctx, window)
	if err != nil {
		span.RecordError(err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{"topics": topics})
}

func (h *AIHandler) ClassifyEntities(c *fiber.Ctx) error {
	ctx, span := observability.StartSpan(c.Context(), "AIHandler.ClassifyEntities")
	defer span.End()

	type request struct {
		Text string `json:"text"`
	}

	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}

	if req.Text == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "text is required"})
	}

	entities, err := h.service.ClassifyEntity(ctx, req.Text)
	if err != nil {
		span.RecordError(err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{"entities": entities})
}
