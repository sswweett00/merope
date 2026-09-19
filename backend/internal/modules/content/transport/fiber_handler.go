package transport

import (
	"local/merope/internal/modules/content/domain"
	"local/merope/internal/core/security"
	"local/merope/internal/core/errors"
	"strconv"
	"strings"

	"github.com/gofiber/fiber/v2"
)

type ContentHandler struct {
	service domain.ContentService
}

func NewContentHandler(service domain.ContentService) *ContentHandler {
	return &ContentHandler{service: service}
}

func (h *ContentHandler) requireVisiblePost(c *fiber.Ctx, postID, viewerID string) (*domain.Signal, error) {
	if strings.TrimSpace(postID) == "" || strings.TrimSpace(viewerID) == "" {
		return nil, fiber.ErrBadRequest
	}
	post, err := h.service.GetSignal(c.Context(), postID)
	if err != nil {
		return nil, err
	}
	if post == nil {
		return nil, fiber.ErrNotFound
	}
	visible, err := h.service.CanViewSignal(c.Context(), viewerID, postID)
	if err != nil {
		return nil, err
	}
	if !visible {
		return nil, fiber.ErrForbidden
	}
	return post, nil
}

func (h *ContentHandler) CreatePost(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	type pollRequest struct {
		Question string   `json:"question"`
		Options  []string `json:"options"`
		EndsAt   string   `json:"ends_at"`
	}
	type request struct {
		Text  string       `json:"text"`
		Media []string     `json:"media"`
		Poll  *pollRequest `json:"poll"`
	}

	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"code":    errors.ErrBadRequest,
			"message": "Invalid request",
		})
	}

	req.Text = security.SanitizeHTML(req.Text)

	var pollData *domain.WavePoolData
	if req.Poll != nil {
		pollData = &domain.WavePoolData{
			Question: req.Poll.Question,
			Options:  req.Poll.Options,
		}
	}

	signal := &domain.Signal{
		AuthorID:    userID,
		ContentText: req.Text,
		MediaURLs:   req.Media,
		Visibility:  req.Visibility,
	}

	post, err := h.service.BroadcastSignal(c.Context(), signal, pollData)
	if err != nil {
		return c.Status(errors.ToHTTPStatus(err)).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}

	return c.Status(fiber.StatusCreated).JSON(post)
}

func (h *ContentHandler) Vote(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	pollID := c.Params("id")
	type request struct {
		OptionID string `json:"option_id"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"code":    errors.ErrBadRequest,
			"message": "Invalid request",
		})
	}

	if err := h.service.Vote(c.Context(), pollID, req.OptionID, userID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}
	return c.JSON(fiber.Map{"message": "Vote casted"})
}

type MeropeAuthor struct {
	ID          string  `json:"id"`
	Username    string  `json:"username"`
	DisplayName string  `json:"display_name"`
	AvatarURL   string  `json:"avatar_url"`
	IsVerified  bool    `json:"is_verified"`
	Influence   float64 `json:"influence_score"`
}

type MeropeResonance struct {
	Type        string `json:"type"`
	Amplitude   int    `json:"amplitude"`
	IsResonated bool   `json:"is_resonated"`
}

type MeropeSignalDTO struct {
	ID                 string            `json:"id"`
	Author             MeropeAuthor      `json:"author"`
	Content            string            `json:"content"`
	Media              []interface{}     `json:"media"`
	Resonances         []MeropeResonance `json:"resonances"`
	Layers             []interface{}     `json:"layers"`
	Cards              []interface{}     `json:"cards"`
	NodeCount          int               `json:"node_count"`
	AmplificationCount int               `json:"amplification_count"`
	CreatedAt          int64             `json:"created_at"`
	IsPinned           bool              `json:"is_pinned"`
	Effect             string            `json:"effect"`
	Frequency          float64           `json:"resonance_frequency"`
}

func toMeropeSignalDTO(s *domain.Signal) MeropeSignalDTO {
	media := make([]interface{}, len(s.MediaURLs))
	for i, url := range s.MediaURLs {
		media[i] = map[string]interface{}{
			"url":  url,
			"type": "image", // Default to image; in production check extension
		}
	}

	resonances := []MeropeResonance{
		{
			Type:        "resonance",
			Amplitude:   s.WaveAmplitude,
			IsResonated: s.IsLiked,
		},
	}

	return MeropeSignalDTO{
		ID: s.ID,
		Author: MeropeAuthor{
			ID:          s.AuthorID,
			Username:    s.AuthorName,
			DisplayName: s.AuthorName,
			AvatarURL:   s.AuthorAvatar,
			IsVerified:  false,
			Influence:   0,
		},
		Content:            s.ContentText,
		Media:              media,
		Resonances:         resonances,
		Layers:             []interface{}{},
		Cards:              []interface{}{},
		NodeCount:          s.CommentCount,
		AmplificationCount: s.ShareCount,
		CreatedAt:          s.CreatedAt.Unix(),
		IsPinned:           s.IsPinned,
		Effect:             s.Effect,
		Frequency:          s.ResonanceScore,
	}
}

func (h *ContentHandler) Feed(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	pageStr := c.Query("page", "0")
	page, _ := strconv.Atoi(pageStr)

	posts, err := h.service.GetResonanceStream(c.Context(), userID, int32(page))
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}

	dtos := make([]MeropeSignalDTO, len(posts))
	for i, p := range posts {
		dtos[i] = toMeropeSignalDTO(p)
	}

	return c.JSON(fiber.Map{
		"items":    dtos,
		"has_more": len(posts) > 0,
	})
}

func (h *ContentHandler) GetPost(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	post, err := h.requireVisiblePost(c, c.Params("id"), userID)
	if err != nil {
		status := errors.ToHTTPStatus(err)
		if err == fiber.ErrNotFound {
			status = fiber.StatusNotFound
		} else if err == fiber.ErrForbidden {
			status = fiber.StatusForbidden
		}
		return c.Status(status).JSON(fiber.Map{"code": errors.GetCode(err), "message": "Unable to process request"})
	}
	return c.JSON(toMeropeSignalDTO(post))
}

func (h *ContentHandler) UpdatePost(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	postID := c.Params("id")
	type request struct {
		Content string   `json:"content"`
		Media   []string `json:"media"`
	}
	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"code":    errors.ErrBadRequest,
			"message": "Invalid request",
		})
	}
	req.Content = security.SanitizeHTML(req.Content)
	post, err := h.service.GetSignal(c.Context(), postID)
	if err != nil || post == nil || post.AuthorID != userID {
		return c.Status(fiber.StatusForbidden).JSON(fiber.Map{
			"code":    errors.ErrForbidden,
			"message": "Not authorized",
		})
	}
	post.ContentText = req.Content
	post.MediaURLs = req.Media
	if err := h.service.UpdateSignal(c.Context(), post); err != nil {
		return c.Status(errors.ToHTTPStatus(err)).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}
	return c.JSON(toMeropeSignalDTO(post))
}

func (h *ContentHandler) DeletePost(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	postID := c.Params("id")
	post, err := h.service.GetSignal(c.Context(), postID)
	if err != nil || post == nil || post.AuthorID != userID {
		return c.Status(fiber.StatusForbidden).JSON(fiber.Map{
			"code":    errors.ErrForbidden,
			"message": "Not authorized",
		})
	}
	if err := h.service.DeleteSignal(c.Context(), postID); err != nil {
		return c.Status(errors.ToHTTPStatus(err)).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}
	return c.SendStatus(fiber.StatusNoContent)
}

func (h *ContentHandler) DeleteComment(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	postID := c.Params("id")
	if _, err := h.requireVisiblePost(c, postID, userID); err != nil {
		return c.Status(errors.ToHTTPStatus(err)).JSON(fiber.Map{"code": errors.GetCode(err), "message": "Unable to process request"})
	}
	commentID := c.Params("comment_id")
	comments, err := h.service.GetSignalNodes(c.Context(), postID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}
	for _, comment := range comments {
		if comment.ID == commentID && comment.AuthorID == userID {
			if err := h.service.DeleteNode(c.Context(), commentID); err != nil {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
			}
			return c.SendStatus(fiber.StatusNoContent)
		}
	}
	return c.Status(fiber.StatusForbidden).JSON(fiber.Map{
			"code":    errors.ErrForbidden,
			"message": "Not authorized",
		})
}

func (h *ContentHandler) React(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	postID := c.Params("id")
	if _, err := h.requireVisiblePost(c, postID, userID); err != nil {
		return c.Status(errors.ToHTTPStatus(err)).JSON(fiber.Map{"code": errors.GetCode(err), "message": "Unable to process request"})
	}

	if err := h.service.AmplifySignal(c.Context(), userID, postID, 1); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}

	return c.JSON(fiber.Map{"message": "Reacted successfully"})
}

func (h *ContentHandler) Like(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	signalID := c.Params("id")
	if _, err := h.requireVisiblePost(c, signalID, userID); err != nil {
		return c.Status(errors.ToHTTPStatus(err)).JSON(fiber.Map{"code": errors.GetCode(err), "message": "Unable to process request"})
	}
	if err := h.service.AmplifySignal(c.Context(), userID, signalID, 1); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}
	return c.SendStatus(fiber.StatusOK)
}

func (h *ContentHandler) Unlike(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	signalID := c.Params("id")
	if _, err := h.requireVisiblePost(c, signalID, userID); err != nil {
		return c.Status(errors.ToHTTPStatus(err)).JSON(fiber.Map{"code": errors.GetCode(err), "message": "Unable to process request"})
	}
	if err := h.service.RemoveResonance(c.Context(), userID, signalID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}
	return c.SendStatus(fiber.StatusOK)
}

func (h *ContentHandler) Repost(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	signalID := c.Params("id")
	if _, err := h.requireVisiblePost(c, signalID, userID); err != nil {
		return c.Status(errors.ToHTTPStatus(err)).JSON(fiber.Map{"code": errors.GetCode(err), "message": "Unable to process request"})
	}
	if err := h.service.ShareSignal(c.Context(), userID, signalID); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}
	return c.SendStatus(fiber.StatusOK)
}

func (h *ContentHandler) AddComment(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	postID := c.Params("id")
	if _, err := h.requireVisiblePost(c, postID, userID); err != nil {
		return c.Status(errors.ToHTTPStatus(err)).JSON(fiber.Map{"code": errors.GetCode(err), "message": "Unable to process request"})
	}
	type request struct {
		Text     string  `json:"text"`
		ParentID *string `json:"parent_id"`
	}

	var req request
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"code":    errors.ErrBadRequest,
			"message": "Invalid request",
		})
	}

	comment, err := h.service.AddNode(c.Context(), postID, userID, req.ParentID, req.Text)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}

	return c.Status(fiber.StatusCreated).JSON(comment)
}

func (h *ContentHandler) GetComments(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)
	postID := c.Params("id")
	if _, err := h.requireVisiblePost(c, postID, userID); err != nil {
		return c.Status(errors.ToHTTPStatus(err)).JSON(fiber.Map{"code": errors.GetCode(err), "message": "Unable to process request"})
	}
	comments, err := h.service.GetSignalNodes(c.Context(), postID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"code":    errors.GetCode(err),
			"message": "Unable to process request",
		})
	}

	return c.JSON(fiber.Map{"comments": comments})
}
