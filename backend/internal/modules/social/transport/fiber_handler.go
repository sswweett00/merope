package transport

import (
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

func (h *SocialHandler) Follow(c *fiber.Ctx) error {
	followerID := c.Locals("user_id").(string)
	followingID := c.Params("id")

	if err := h.service.Follow(c.Context(), followerID, followingID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": err.Error(),
		})
	}

	return c.JSON(fiber.Map{"message": "Followed successfully"})
}

func (h *SocialHandler) Unfollow(c *fiber.Ctx) error {
	followerID := c.Locals("user_id").(string)
	followingID := c.Params("id")

	if err := h.service.Unfollow(c.Context(), followerID, followingID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": err.Error(),
		})
	}

	return c.JSON(fiber.Map{"message": "Unfollowed successfully"})
}

func (h *SocialHandler) Mutuals(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	otherID := c.Query("other_id")
	users, err := h.service.GetMutualFriends(c.Context(), userID, otherID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": err.Error(),
		})
	}

	return c.JSON(fiber.Map{"users": users})
}

func (h *SocialHandler) Profile(c *fiber.Ctx) error {
	userID := c.Params("id")
	users, err := h.service.GetMutualFriends(c.Context(), userID, "")
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": err.Error(),
		})
	}
	if len(users) == 0 {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"code":    errors.ErrNotFound,
			"message": "User not found",
		})
	}
	return c.JSON(users[0])
}

func (h *SocialHandler) Search(c *fiber.Ctx) error {
	query := c.Query("q", "")
	users, err := h.service.GlobalSearch(c.Context(), query)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": err.Error(),
		})
	}
	return c.JSON(fiber.Map{"users": users})
}

func (h *SocialHandler) Followers(c *fiber.Ctx) error {
	userID := c.Params("id")
	users, err := h.service.GetFollowers(c.Context(), userID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": err.Error(),
		})
	}
	return c.JSON(fiber.Map{"users": users})
}

func (h *SocialHandler) Following(c *fiber.Ctx) error {
	userID := c.Params("id")
	users, err := h.service.GetFollowing(c.Context(), userID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": err.Error(),
		})
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
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": err.Error(),
		})
	}

	return c.JSON(fiber.Map{"circle_id": circleID})
}
