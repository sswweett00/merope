package transport

import (
	"strconv"
	"strings"

	"github.com/gofiber/fiber/v2"

	"local/merope/internal/modules/search/domain"
)

type SearchHandler struct {
	service domain.SearchService
}

func NewSearchHandler(service domain.SearchService) *SearchHandler {
	return &SearchHandler{service: service}
}

func (h *SearchHandler) Search(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	query := c.Query("q", "")
	_ = query

	if query == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "query is required"})
	}

	results, err := h.service.UniversalSearch(c.Context(), userID, query)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{"results": results, "query": query})
}

func (h *SearchHandler) Autocomplete(c *fiber.Ctx) error {
	query := c.Query("q", "")
	limit, _ := strconv.Atoi(c.Query("limit", "10"))

	if query == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "query is required"})
	}

	results, err := h.service.GetAutocomplete(c.Context(), query, limit)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{"suggestions": results})
}

func (h *SearchHandler) GetTrending(c *fiber.Ctx) error {
	results, err := h.service.SuggestPeople(c.Context(), "")
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{"trending": results})
}

func (h *SearchHandler) UpdateLocation(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	type request struct {
		Lat   float64 `json:"lat"`
		Lon   float64 `json:"lon"`
		Ghost bool    `json:"ghost"`
	}

	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid request"})
	}

	if err := h.service.UpdateLocation(c.Context(), userID, req.Lat, req.Lon, req.Ghost); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.SendStatus(fiber.StatusOK)
}

func (h *SearchHandler) GetNearby(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	lat, _ := strconv.ParseFloat(c.Query("lat", "0"), 64)
	lon, _ := strconv.ParseFloat(c.Query("lon", "0"), 64)
	radius, _ := strconv.ParseFloat(c.Query("radius", "50"), 64)

	if lat == 0 || lon == 0 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "location parameters required"})
	}

	users, err := h.service.DiscoverNearby(c.Context(), lat, lon, radius, 50)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{"nearby": users, "user_id": userID})
}


func (h *SearchHandler) GetHistory(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	history, err := h.service.GetRecentHistory(c.Context(), userID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "failed to load search history"})
	}
	return c.JSON(fiber.Map{"history": history})
}

func (h *SearchHandler) GetInterests(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	interests, err := h.service.GetInterests(c.Context(), userID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "failed to load interests"})
	}
	return c.JSON(fiber.Map{"interests": interests})
}

func (h *SearchHandler) UpdateInterests(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	var req struct {
		Interests []string `json:"interests"`
	}
	if err := c.BodyParser(&req); err != nil || len(req.Interests) > 50 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid interests"})
	}
	for i, interest := range req.Interests {
		req.Interests[i] = strings.TrimSpace(interest)
	}
	if err := h.service.UpdateInterests(c.Context(), userID, req.Interests); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "failed to update interests"})
	}
	return c.SendStatus(fiber.StatusNoContent)
}
