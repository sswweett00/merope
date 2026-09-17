package transport

import (
	"fmt"
	"strconv"
	"strings"
	"time"

	"local/merope/internal/modules/community/domain"

	"github.com/gofiber/fiber/v2"
)

type CommunityHandler struct {
	service domain.CommunityService
	repo    domain.CommunityRepository
}

func NewCommunityHandler(service domain.CommunityService, repo domain.CommunityRepository) *CommunityHandler {
	return &CommunityHandler{service: service, repo: repo}
}

func userID(c *fiber.Ctx) (string, error) {
	value, ok := c.Locals("user_id").(string)
	if !ok || strings.TrimSpace(value) == "" {
		return "", fiber.ErrUnauthorized
	}
	return value, nil
}

func pageArgs(c *fiber.Ctx, defaultLimit int) (int32, int32) {
	limit, _ := strconv.Atoi(c.Query("limit", strconv.Itoa(defaultLimit)))
	offset, _ := strconv.Atoi(c.Query("offset", "0"))
	if limit <= 0 || limit > 100 { limit = defaultLimit }
	if offset < 0 { offset = 0 }
	return int32(limit), int32(offset)
}

func writeCommunityError(c *fiber.Ctx, err error) error {
	status := fiber.StatusInternalServerError
	if err == fiber.ErrUnauthorized { status = fiber.StatusUnauthorized }
	if err == fiber.ErrBadRequest { status = fiber.StatusBadRequest }
	return c.Status(status).JSON(fiber.Map{"error": err.Error()})
}

func (h *CommunityHandler) ListCommunities(c *fiber.Ctx) error {
	uid, err := userID(c); if err != nil { return writeCommunityError(c, err) }
	limit, offset := pageArgs(c, 20)
	items, err := h.repo.ListCommunities(c.Context(), uid, c.Query("category"), limit, offset)
	if err != nil { return writeCommunityError(c, err) }
	return c.JSON(items)
}

func (h *CommunityHandler) GetCommunity(c *fiber.Ctx) error {
	item, err := h.repo.GetCommunity(c.Context(), c.Params("id"))
	if err != nil { return writeCommunityError(c, err) }
	return c.JSON(item)
}

func (h *CommunityHandler) CreateCommunity(c *fiber.Ctx) error {
	ownerID, err := userID(c); if err != nil { return writeCommunityError(c, err) }
	var req struct { Name string `json:"name"`; Description string `json:"description"`; IsPrivate bool `json:"isPrivate"`; Slug string `json:"slug"` }
	if err := c.BodyParser(&req); err != nil { return writeCommunityError(c, fiber.ErrBadRequest) }
	item, err := h.service.CreateGroup(c.Context(), ownerID, req.Name, req.Description, req.IsPrivate)
	if err != nil { return writeCommunityError(c, err) }
	if req.Slug != "" { item.Slug = strings.TrimSpace(req.Slug) }
	return c.Status(fiber.StatusCreated).JSON(item)
}

func (h *CommunityHandler) Join(c *fiber.Ctx) error {
	uid, err := userID(c); if err != nil { return writeCommunityError(c, err) }
	if err := h.service.Join(c.Context(), c.Params("id"), uid); err != nil { return writeCommunityError(c, err) }
	return c.JSON(fiber.Map{"message":"joined"})
}

func (h *CommunityHandler) Leave(c *fiber.Ctx) error {
	uid, err := userID(c); if err != nil { return writeCommunityError(c, err) }
	if err := h.service.Leave(c.Context(), c.Params("id"), uid); err != nil { return writeCommunityError(c, err) }
	return c.JSON(fiber.Map{"message":"left"})
}

func (h *CommunityHandler) UpdateSettings(c *fiber.Ctx) error {
	id := c.Params("id")
	current, err := h.repo.GetCommunity(c.Context(), id); if err != nil { return writeCommunityError(c, err) }
	var settings domain.CommunitySettings
	if err := c.BodyParser(&settings); err != nil { return writeCommunityError(c, fiber.ErrBadRequest) }
	current.Settings = settings
	if err := h.repo.UpdateCommunity(c.Context(), id, current); err != nil { return writeCommunityError(c, err) }
	return c.JSON(current)
}

func (h *CommunityHandler) GetGuidelines(c *fiber.Ctx) error {
	items, err := h.repo.GetCommunityGuidelines(c.Context(), c.Params("id")); if err != nil { return writeCommunityError(c, err) }
	return c.JSON(items)
}

func (h *CommunityHandler) UpdateGuidelines(c *fiber.Ctx) error {
	var req struct { Guidelines []*domain.Guideline `json:"guidelines"` }
	if err := c.BodyParser(&req); err != nil { return writeCommunityError(c, fiber.ErrBadRequest) }
	if err := h.service.SetCommunityGuidelines(c.Context(), c.Params("id"), req.Guidelines); err != nil { return writeCommunityError(c, err) }
	return c.JSON(fiber.Map{"message":"updated"})
}

func parseFlexibleTime(value string) (time.Time, error) {
	if value == "" { return time.Time{}, fmt.Errorf("time is required") }
	if unix, err := strconv.ParseInt(value, 10, 64); err == nil { return time.Unix(unix, 0), nil }
	return time.Parse(time.RFC3339, value)
}

func (h *CommunityHandler) ListEvents(c *fiber.Ctx) error {
	limit, offset := pageArgs(c, 20)
	var communityID *string
	if raw := c.Query("community_id"); raw != "" { communityID = &raw }
	uid, err := userID(c); if err != nil { return writeCommunityError(c, err) }
	items, err := h.repo.ListEvents(c.Context(), communityID, uid, c.Query("status"), limit, offset)
	if err != nil { return writeCommunityError(c, err) }
	return c.JSON(items)
}

func (h *CommunityHandler) UpcomingEvents(c *fiber.Ctx) error {
	uid, err := userID(c); if err != nil { return writeCommunityError(c, err) }
	limit, _ := pageArgs(c, 20)
	items, err := h.repo.GetUpcomingEvents(c.Context(), uid, limit); if err != nil { return writeCommunityError(c, err) }
	return c.JSON(items)
}

func (h *CommunityHandler) CreateEvent(c *fiber.Ctx) error {
	uid, err := userID(c); if err != nil { return writeCommunityError(c, err) }
	var req struct {
		CommunityID *string `json:"communityId"`; Title string `json:"title"`; Description string `json:"description"`
		StartTime string `json:"startTime"`; EndTime string `json:"endTime"`; LocationName string `json:"locationName"`
		Latitude *float64 `json:"latitude"`; Longitude *float64 `json:"longitude"`; LocationURL string `json:"locationUrl"`
		MaxAttendees int32 `json:"maxAttendees"`; IsPublic bool `json:"isPublic"`; IsRecurring bool `json:"isRecurring"`
		RecurrencePattern string `json:"recurrencePattern"`; ImageURL string `json:"imageUrl"`; Status string `json:"status"`
		TicketInfo domain.EventTicketInfo `json:"ticketInfo"`
	}
	if err := c.BodyParser(&req); err != nil { return writeCommunityError(c, fiber.ErrBadRequest) }
	start, err := parseFlexibleTime(req.StartTime); if err != nil { return writeCommunityError(c, fiber.ErrBadRequest) }
	end, err := parseFlexibleTime(req.EndTime); if err != nil { return writeCommunityError(c, fiber.ErrBadRequest) }
	event := &domain.Event{CreatorID: uid, CommunityID:req.CommunityID, Title:req.Title, Description:req.Description, StartTime:start, EndTime:end, LocationName:req.LocationName, Latitude:req.Latitude, Longitude:req.Longitude, LocationURL:req.LocationURL, MaxAttendees:req.MaxAttendees, IsPublic:req.IsPublic, IsRecurring:req.IsRecurring, RecurrencePattern:req.RecurrencePattern, ImageURL:req.ImageURL, Status:req.Status, TicketInfo:req.TicketInfo}
	created, err := h.service.OrganizeEvent(c.Context(), event); if err != nil { return writeCommunityError(c, err) }
	return c.Status(fiber.StatusCreated).JSON(created)
}

func (h *CommunityHandler) RSVP(c *fiber.Ctx) error {
	uid, err := userID(c); if err != nil { return writeCommunityError(c, err) }
	var req struct { Status string `json:"status"` }
	if err := c.BodyParser(&req); err != nil { return writeCommunityError(c, fiber.ErrBadRequest) }
	if req.Status == "" { req.Status = "attending" }
	if err := h.repo.RSVP(c.Context(), c.Params("id"), uid, req.Status); err != nil { return writeCommunityError(c, err) }
	return c.JSON(fiber.Map{"message":"rsvp recorded"})
}

func (h *CommunityHandler) CancelEvent(c *fiber.Ctx) error {
	if err := h.service.CancelEvent(c.Context(), c.Params("id")); err != nil { return writeCommunityError(c, err) }
	return c.JSON(fiber.Map{"message":"cancelled"})
}

func (h *CommunityHandler) ListCollectives(c *fiber.Ctx) error {
	limit, offset := pageArgs(c, 20); items, err := h.repo.GetCollectives(c.Context(), limit, offset); if err != nil { return writeCommunityError(c, err) }
	return c.JSON(items)
}

func (h *CommunityHandler) CreateCollective(c *fiber.Ctx) error {
	var req struct { Name string `json:"name"`; Description string `json:"description"`; Icon string `json:"icon"` }
	if err := c.BodyParser(&req); err != nil { return writeCommunityError(c, fiber.ErrBadRequest) }
	item, err := h.service.FormCollective(c.Context(), req.Name, req.Description, req.Icon); if err != nil { return writeCommunityError(c, err) }
	return c.Status(fiber.StatusCreated).JSON(item)
}

func (h *CommunityHandler) JoinCollective(c *fiber.Ctx) error {
	uid, err := userID(c); if err != nil { return writeCommunityError(c, err) }
	if err := h.repo.JoinCollective(c.Context(), c.Params("id"), uid); err != nil { return writeCommunityError(c, err) }
	return c.JSON(fiber.Map{"message":"joined"})
}

func (h *CommunityHandler) ListThreads(c *fiber.Ctx) error {
	limit, offset := pageArgs(c, 20); items, err := h.repo.GetThreads(c.Context(), c.Params("id"), limit, offset); if err != nil { return writeCommunityError(c, err) }
	return c.JSON(items)
}

func (h *CommunityHandler) CreateThread(c *fiber.Ctx) error {
	uid, err := userID(c); if err != nil { return writeCommunityError(c, err) }
	var req struct { Title string `json:"title"`; Content string `json:"content"` }
	if err := c.BodyParser(&req); err != nil { return writeCommunityError(c, fiber.ErrBadRequest) }
	item, err := h.service.StartThread(c.Context(), c.Params("id"), uid, req.Title, req.Content); if err != nil { return writeCommunityError(c, err) }
	return c.Status(fiber.StatusCreated).JSON(item)
}

func (h *CommunityHandler) ResonateThread(c *fiber.Ctx) error {
	var req struct { Delta int `json:"delta"` }
	if err := c.BodyParser(&req); err != nil { return writeCommunityError(c, fiber.ErrBadRequest) }
	if err := h.repo.ResonateThread(c.Context(), c.Params("id"), req.Delta); err != nil { return writeCommunityError(c, err) }
	return c.JSON(fiber.Map{"message":"resonance updated"})
}

func (h *CommunityHandler) ThreadReplies(c *fiber.Ctx) error {
	limit, offset := pageArgs(c, 50); items, err := h.repo.GetThreadReplies(c.Context(), c.Params("id"), limit, offset); if err != nil { return writeCommunityError(c, err) }
	return c.JSON(items)
}

func (h *CommunityHandler) CreateThreadReply(c *fiber.Ctx) error {
	uid, err := userID(c); if err != nil { return writeCommunityError(c, err) }
	var req struct { Content string `json:"content"`; ParentID *string `json:"parentId"` }
	if err := c.BodyParser(&req); err != nil { return writeCommunityError(c, fiber.ErrBadRequest) }
	item, err := h.service.ReplyToThread(c.Context(), c.Params("id"), uid, req.Content); if err != nil { return writeCommunityError(c, err) }
	item.ParentID = req.ParentID
	return c.Status(fiber.StatusCreated).JSON(item)
}

func (h *CommunityHandler) PinThread(c *fiber.Ctx) error {
	var req struct { Pinned bool `json:"pinned"` }; if err := c.BodyParser(&req); err != nil { return writeCommunityError(c, fiber.ErrBadRequest) }
	if err := h.service.PinThread(c.Context(), c.Params("id"), req.Pinned); err != nil { return writeCommunityError(c, err) }
	return c.JSON(fiber.Map{"message":"pin updated"})
}

func (h *CommunityHandler) LockThread(c *fiber.Ctx) error {
	var req struct { Locked bool `json:"locked"` }; if err := c.BodyParser(&req); err != nil { return writeCommunityError(c, fiber.ErrBadRequest) }
	if err := h.service.LockThread(c.Context(), c.Params("id"), req.Locked); err != nil { return writeCommunityError(c, err) }
	return c.JSON(fiber.Map{"message":"lock updated"})
}

func (h *CommunityHandler) Members(c *fiber.Ctx) error {
	limit, offset := pageArgs(c, 50); items, err := h.repo.GetCommunityMembers(c.Context(), c.Params("id"), c.Query("role"), limit, offset); if err != nil { return writeCommunityError(c, err) }
	return c.JSON(items)
}

func (h *CommunityHandler) UpdateMemberRole(c *fiber.Ctx) error {
	if _, err := userID(c); err != nil { return writeCommunityError(c, err) }
	var req struct { Role string `json:"role"` }; if err := c.BodyParser(&req); err != nil || strings.TrimSpace(req.Role)=="" { return writeCommunityError(c, fiber.ErrBadRequest) }
	if err := h.service.PromoteMember(c.Context(), c.Params("id"), c.Params("member_id"), req.Role); err != nil { return writeCommunityError(c, err) }
	return c.JSON(fiber.Map{"message":"role updated"})
}

func (h *CommunityHandler) BanMember(c *fiber.Ctx) error {
	if _, err := userID(c); err != nil { return writeCommunityError(c, err) }
	var req struct { Reason string `json:"reason"` }; if err := c.BodyParser(&req); err != nil { return writeCommunityError(c, fiber.ErrBadRequest) }
	if err := h.service.BanMember(c.Context(), c.Params("id"), c.Params("member_id"), req.Reason, nil); err != nil { return writeCommunityError(c, err) }
	return c.JSON(fiber.Map{"message":"member banned"})
}

func (h *CommunityHandler) UnbanMember(c *fiber.Ctx) error {
	if _, err := userID(c); err != nil { return writeCommunityError(c, err) }
	if err := h.service.UnbanMember(c.Context(), c.Params("id"), c.Params("member_id")); err != nil { return writeCommunityError(c, err) }
	return c.JSON(fiber.Map{"message":"member unbanned"})
}

func (h *CommunityHandler) Subscriptions(c *fiber.Ctx) error {
	uid, err := userID(c); if err != nil { return writeCommunityError(c, err) }
	items, err := h.repo.GetUserSubscriptions(c.Context(), uid); if err != nil { return writeCommunityError(c, err) }
	return c.JSON(items)
}

func (h *CommunityHandler) CreateSubscription(c *fiber.Ctx) error {
	uid, err := userID(c); if err != nil { return writeCommunityError(c, err) }
	var req struct { CreatorID string `json:"creatorId"`; Tier string `json:"tier"` }
	if err := c.BodyParser(&req); err != nil || req.CreatorID=="" || req.Tier=="" { return writeCommunityError(c, fiber.ErrBadRequest) }
	id := fmt.Sprintf("%s-%d", uid, time.Now().UnixNano())
	if err := h.service.SubscribeToCreator(c.Context(), id, req.CreatorID, req.Tier); err != nil { return writeCommunityError(c, err) }
	item, err := h.repo.GetSubscription(c.Context(), id); if err != nil { return writeCommunityError(c, err) }
	return c.Status(fiber.StatusCreated).JSON(item)
}

func (h *CommunityHandler) CancelSubscription(c *fiber.Ctx) error {
	if _, err := userID(c); err != nil { return writeCommunityError(c, err) }
	if err := h.service.CancelSubscription(c.Context(), c.Params("id")); err != nil { return writeCommunityError(c, err) }
	return c.JSON(fiber.Map{"message":"cancelled"})
}

func (h *CommunityHandler) UpdateSubscription(c *fiber.Ctx) error {
	if _, err := userID(c); err != nil { return writeCommunityError(c, err) }
	var req struct { Tier string `json:"tier"` }; if err := c.BodyParser(&req); err != nil || req.Tier=="" { return writeCommunityError(c, fiber.ErrBadRequest) }
	if err := h.service.UpdateSubscriptionTier(c.Context(), c.Params("id"), req.Tier); err != nil { return writeCommunityError(c, err) }
	return c.JSON(fiber.Map{"message":"updated"})
}

func (h *CommunityHandler) Analytics(c *fiber.Ctx) error {
	item, err := h.service.GetCommunityAnalytics(c.Context(), c.Params("id"), c.Query("period", "30d")); if err != nil { return writeCommunityError(c, err) }
	return c.JSON(item)
}
