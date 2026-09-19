package transport

import (
	stdErrors "errors"
	"local/merope/internal/modules/social/domain"
	"local/merope/internal/core/errors"

	"github.com/gofiber/fiber/v2"
)

type SocialHandler struct {
	service domain.SocialService
}

func NewSocialHandler(service domain.SocialService) *SocialHandler {
	return &SocialHandler{service: service}
}

func writeSocialError(c *fiber.Ctx, err error) error {
	status := fiber.StatusInternalServerError
	message := "social operation failed"
	if stdErrors.Is(err, domain.ErrProfileForbidden) {
		status = fiber.StatusForbidden
		message = "forbidden"
	} else if err == fiber.ErrUnauthorized {
		status = fiber.StatusUnauthorized
		message = "authentication required"
	} else if err == fiber.ErrBadRequest {
		status = fiber.StatusBadRequest
		message = "invalid request"
	} else if err == fiber.ErrForbidden {
		status = fiber.StatusForbidden
		message = "forbidden"
	} else if err == fiber.ErrNotFound {
		status = fiber.StatusNotFound
		message = "not found"
	}
	return c.Status(status).JSON(fiber.Map{"code": errors.GetCode(err), "message": message})
}

func (h *SocialHandler) Follow(c *fiber.Ctx) error {
	followerID := c.Locals("user_id").(string)
	followingID := c.Params("id")

	if err := h.service.Follow(c.Context(), followerID, followingID); err != nil {
		return writeSocialError(c, err)
	}

	return c.JSON(fiber.Map{"message": "Followed successfully"})
}

func (h *SocialHandler) Unfollow(c *fiber.Ctx) error {
	followerID := c.Locals("user_id").(string)
	followingID := c.Params("id")

	if err := h.service.Unfollow(c.Context(), followerID, followingID); err != nil {
		return writeSocialError(c, err)
	}

	return c.JSON(fiber.Map{"message": "Unfollowed successfully"})
}

func (h *SocialHandler) Mutuals(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	otherID := c.Query("other_id")
	users, err := h.service.GetMutualFriends(c.Context(), userID, otherID)
	if err != nil {
		return writeSocialError(c, err)
	}

	return c.JSON(fiber.Map{"users": users})
}

func (h *SocialHandler) Profile(c *fiber.Ctx) error {
	userID := c.Params("id")
viewerID, _ := c.Locals("user_id").(string)
	profile, err := h.service.GetProfile(c.Context(), viewerID, userID)
	if err != nil {
		return writeSocialError(c, err)
	}
	return c.JSON(profile)
}

func (h *SocialHandler) Search(c *fiber.Ctx) error {
	userID, _ := c.Locals("user_id").(string)
	query := c.Query("q", "")
	users, err := h.service.GlobalSearch(c.Context(), userID, query)
	if err != nil {
		return writeSocialError(c, err)
	}
	return c.JSON(fiber.Map{"users": users})
}

func (h *SocialHandler) Followers(c *fiber.Ctx) error {
	userID := c.Params("id")
	users, err := h.service.GetFollowers(c.Context(), userID)
	if err != nil {
		return writeSocialError(c, err)
	}
	return c.JSON(fiber.Map{"users": users})
}

func (h *SocialHandler) Following(c *fiber.Ctx) error {
	userID := c.Params("id")
	users, err := h.service.GetFollowing(c.Context(), userID)
	if err != nil {
		return writeSocialError(c, err)
	}
	return c.JSON(fiber.Map{"users": users})
}

func (h *SocialHandler) CreateCircle(c *fiber.Ctx) error {
	ownerID := c.Locals("user_id").(string)
	type request struct {
		Name    string   `json:"name"`
		Members []string `json:"members"`
	}

	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"code":    errors.ErrBadRequest,
			"message": "Invalid request",
		})
	}

	circleID, err := h.service.CreatePrivacyCircle(c.Context(), ownerID, req.Name, req.Members)
	if err != nil {
		return writeSocialError(c, err)
	}

	return c.JSON(fiber.Map{"circle_id": circleID})
}
