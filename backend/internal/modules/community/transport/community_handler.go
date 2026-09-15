package transport

import (
	"time"

	"local/merope/internal/modules/community/domain"

	"github.com/gofiber/fiber/v2"
)

type CommunityHandler struct {
	service domain.CommunityService
}

func NewCommunityHandler(service domain.CommunityService) *CommunityHandler {
	return &CommunityHandler{service: service}
}

func (h *CommunityHandler) CreateCommunity(c *fiber.Ctx) error {
	ownerID := c.Locals("user_id").(string)

	var req struct {
		Name        string `json:"name"`
		Description string `json:"description"`
		IsPrivate   bool   `json:"is_private"`
	}

	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}

	comm, err := h.service.CreateGroup(c.Context(), ownerID, req.Name, req.Description, req.IsPrivate)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"community":    comm,
		"community_id": comm.ID,
	})
}

func (h *CommunityHandler) Join(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	commID := c.Params("id")

	if err := h.service.Join(c.Context(), commID, userID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{"message": "Joined community successfully"})
}

func (h *CommunityHandler) CreateEvent(c *fiber.Ctx) error {
	var req struct {
		CommunityID *string `json:"community_id"`
		Title       string  `json:"title"`
		Description string  `json:"description"`
		StartTime   int64   `json:"start_time"`
		EndTime     int64   `json:"end_time"`
		LocationName string `json:"location_name"`
	}

	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request body"})
	}

	event := &domain.Event{
		CommunityID:  req.CommunityID,
		Title:        req.Title,
		Description:  req.Description,
		StartTime:    time.Unix(req.StartTime, 0),
		EndTime:      time.Unix(req.EndTime, 0),
		LocationName: req.LocationName,
	}

	created, err := h.service.OrganizeEvent(c.Context(), event)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"event":     created,
		"event_id":  created.ID,
	})
}

func (h *CommunityHandler) Rsvp(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	eventID := c.Params("id")

	if err := h.service.AttendEvent(c.Context(), eventID, userID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{"message": "RSVP recorded"})
}