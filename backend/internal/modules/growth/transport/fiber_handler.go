package transport

import (
    "github.com/gofiber/fiber/v2"

    "local/merope/internal/modules/growth/domain"
)

type GrowthHandler struct {
    service domain.GrowthService
}

func NewGrowthHandler(service domain.GrowthService) *GrowthHandler {
    return &GrowthHandler{service: service}
}

func (h *GrowthHandler) TrackSignup(c *fiber.Ctx) error {
    var req struct {
        ReferrerID string `json:"referrer_id"`
        ReferredID string `json:"referred_id"`
        Code       string `json:"code"`
    }
    if err := c.BodyParser(&req); err != nil {
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid request body"})
    }
    if err := h.service.TrackSignup(c.Context(), req.ReferrerID, req.ReferredID, req.Code); err != nil {
        return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
    }
    return c.Status(fiber.StatusCreated).JSON(fiber.Map{"message": "referral tracked"})
}

func (h *GrowthHandler) Profile(c *fiber.Ctx) error {
    uid := c.Locals("user_id").(string)
    profile, err := h.service.GetProfile(c.Context(), uid)
    if err != nil {
        return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
    }
    return c.JSON(profile)
}

func (h *GrowthHandler) RecordEvent(c *fiber.Ctx) error {
    uid := c.Locals("user_id").(string)
    var req struct {
        Action   string `json:"action"`
        SourceID string `json:"source_id"`
    }
    if err := c.BodyParser(&req); err != nil {
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid request body"})
    }
    result, err := h.service.RecordEvent(c.Context(), uid, req.Action, req.SourceID)
    if err != nil {
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": err.Error()})
    }
    return c.JSON(result)
}

func (h *GrowthHandler) Quests(c *fiber.Ctx) error {
    uid := c.Locals("user_id").(string)
    cadence := c.Query("cadence", "daily")
    quests, err := h.service.ListQuests(c.Context(), uid, cadence)
    if err != nil {
        return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
    }
    return c.JSON(quests)
}

func (h *GrowthHandler) ClaimQuest(c *fiber.Ctx) error {
    uid := c.Locals("user_id").(string)
    quest, err := h.service.ClaimQuest(c.Context(), uid, c.Params("id"))
    if err != nil {
        return c.Status(fiber.StatusConflict).JSON(fiber.Map{"error": err.Error()})
    }
    return c.JSON(quest)
}

func (h *GrowthHandler) ActivateBoost(c *fiber.Ctx) error {
    uid := c.Locals("user_id").(string)
    profile, err := h.service.ActivateBoost(c.Context(), uid)
    if err != nil {
        return c.Status(fiber.StatusConflict).JSON(fiber.Map{"error": err.Error()})
    }
    return c.JSON(profile)
}

func (h *GrowthHandler) StreakShield(c *fiber.Ctx) error {
    uid := c.Locals("user_id").(string)
    profile, err := h.service.ClaimStreakShield(c.Context(), uid)
    if err != nil {
        return c.Status(fiber.StatusConflict).JSON(fiber.Map{"error": err.Error()})
    }
    return c.JSON(profile)
}

func (h *GrowthHandler) Achievements(c *fiber.Ctx) error {
    uid := c.Locals("user_id").(string)
    achievements, err := h.service.ListAchievements(c.Context(), uid)
    if err != nil {
        return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
    }
    return c.JSON(achievements)
}

func (h *GrowthHandler) SeasonLeaderboard(c *fiber.Ctx) error {
    uid := c.Locals("user_id").(string)
    entries, err := h.service.GetSeasonLeaderboard(c.Context(), uid, 50)
    if err != nil {
        return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
    }
    return c.JSON(entries)
}
