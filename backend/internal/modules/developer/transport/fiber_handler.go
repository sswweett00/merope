package transport

import (
	"local/merope/internal/modules/developer/domain"
	"github.com/gofiber/fiber/v2"
)

type DeveloperHandler struct{ service domain.RuntimeDeveloperService }
func NewDeveloperHandler(service domain.RuntimeDeveloperService)*DeveloperHandler{return &DeveloperHandler{service:service}}
func userID(c *fiber.Ctx)string{if v,ok:=c.Locals("user_id").(string);ok{return v};return ""}
func writeErr(c *fiber.Ctx,err error)error{if err==nil{return nil};return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error":err.Error()})}

func (h *DeveloperHandler) requireAppOwner(c *fiber.Ctx, appID string) error {
	uid := userID(c)
	if uid == "" {
		return fiber.ErrUnauthorized
	}
	app, err := h.service.GetApp(c.Context(), appID)
	if err != nil {
		return err
	}
	if app == nil || app.OwnerID != uid {
		return fiber.ErrForbidden
	}
	return nil
}

func (h *DeveloperHandler) requireKeyOwner(c *fiber.Ctx, keyID string) error {
	key, err := h.service.GetAPIKey(c.Context(), keyID)
	if err != nil {
		return err
	}
	if key == nil {
		return fiber.ErrNotFound
	}
	return h.requireAppOwner(c, key.AppID)
}

func (h *DeveloperHandler) requireWebhookOwner(c *fiber.Ctx, webhookID string) error {
	webhook, err := h.service.GetWebhook(c.Context(), webhookID)
	if err != nil {
		return err
	}
	if webhook == nil {
		return fiber.ErrNotFound
	}
	return h.requireAppOwner(c, webhook.AppID)
}

func (h *DeveloperHandler) requireBotOwner(c *fiber.Ctx, botID string) error {
	bot, err := h.service.GetBot(c.Context(), botID)
	if err != nil {
		return err
	}
	if bot == nil {
		return fiber.ErrNotFound
	}
	return h.requireAppOwner(c, bot.AppID)
}

func(h *DeveloperHandler)ListApps(c *fiber.Ctx)error{owner:=userID(c);if owner==""{return writeErr(c,fiber.ErrUnauthorized)};apps,err:=h.service.GetApps(c.Context(),owner);if err!=nil{return writeErr(c,err)};return c.JSON(apps)}
func(h *DeveloperHandler)GetApp(c *fiber.Ctx)error{if err:=h.requireAppOwner(c,c.Params("app_id"));err!=nil{return writeErr(c,err)};app,err:=h.service.GetApp(c.Context(),c.Params("app_id"));if err!=nil{return writeErr(c,err)};if app!=nil{app.ClientSecret=""};return c.JSON(app)}
func(h *DeveloperHandler)CreateApp(c *fiber.Ctx)error{owner:=userID(c);if owner==""{return writeErr(c,fiber.ErrUnauthorized)};var req struct{Name string `json:"name"`;Description string `json:"description"`};if err:=c.BodyParser(&req);err!=nil{return writeErr(c,err)};app,err:=h.service.RegisterApp(c.Context(),owner,req.Name,req.Description);if err!=nil{return writeErr(c,err)};app.ClientSecret="";return c.Status(fiber.StatusCreated).JSON(app)}
func(h *DeveloperHandler)UpdateApp(c *fiber.Ctx)error{if err:=h.requireAppOwner(c,c.Params("app_id"));err!=nil{return writeErr(c,err)};var app domain.App;if err:=c.BodyParser(&app);err!=nil{return writeErr(c,err)};app.ID=c.Params("app_id");if err:=h.service.UpdateApp(c.Context(),&app);err!=nil{return writeErr(c,err)};updated,err:=h.service.GetApp(c.Context(),app.ID);if err!=nil{return writeErr(c,err)};if updated!=nil{updated.ClientSecret=""};return c.JSON(updated)}
func(h *DeveloperHandler)DeleteApp(c *fiber.Ctx)error{if err:=h.requireAppOwner(c,c.Params("app_id"));err!=nil{return writeErr(c,err)};if err:=h.service.DeleteApp(c.Context(),c.Params("app_id"));err!=nil{return writeErr(c,err)};return c.SendStatus(fiber.StatusNoContent)}
func(h *DeveloperHandler)VerifyApp(c *fiber.Ctx)error{if err:=h.requireAppOwner(c,c.Params("app_id"));err!=nil{return writeErr(c,err)};if err:=h.service.VerifyApp(c.Context(),c.Params("app_id"));err!=nil{return writeErr(c,err)};return c.SendStatus(fiber.StatusNoContent)}
func(h *DeveloperHandler)ListKeys(c *fiber.Ctx)error{if err:=h.requireAppOwner(c,c.Params("app_id"));err!=nil{return writeErr(c,err)};keys,err:=h.service.ListAPIKeys(c.Context(),c.Params("app_id"));if err!=nil{return writeErr(c,err)};for _,k:=range keys{k.KeyHash="";k.RawKey=""};return c.JSON(fiber.Map{"keys":keys})}
func(h *DeveloperHandler)GetKey(c *fiber.Ctx)error{if err:=h.requireKeyOwner(c,c.Params("key_id"));err!=nil{return writeErr(c,err)};k,err:=h.service.GetAPIKey(c.Context(),c.Params("key_id"));if err!=nil{return writeErr(c,err)};if k!=nil{k.KeyHash="";k.RawKey=""};return c.JSON(k)}
func(h *DeveloperHandler)CreateKey(c *fiber.Ctx)error{if err:=h.requireAppOwner(c,c.Params("app_id"));err!=nil{return writeErr(c,err)};var req struct{Name string `json:"name"`;Description string `json:"description"`;Scopes []string `json:"scopes"`;TTLDays int `json:"ttl_days"`};if err:=c.BodyParser(&req);err!=nil{return writeErr(c,err)};k,err:=h.service.CreateAPIKey(c.Context(),c.Params("app_id"),req.Name,req.Description,req.Scopes,req.TTLDays);if err!=nil{return writeErr(c,err)};return c.Status(fiber.StatusCreated).JSON(k)}
func(h *DeveloperHandler)UpdateKey(c *fiber.Ctx)error{if err:=h.requireKeyOwner(c,c.Params("key_id"));err!=nil{return writeErr(c,err)};var k domain.APIKey;if err:=c.BodyParser(&k);err!=nil{return writeErr(c,err)};k.ID=c.Params("key_id");if err:=h.service.UpdateAPIKey(c.Context(),&k);err!=nil{return writeErr(c,err)};k.KeyHash="";k.RawKey="";return c.JSON(k)}
func(h *DeveloperHandler)RevokeKey(c *fiber.Ctx)error{if err:=h.requireKeyOwner(c,c.Params("key_id"));err!=nil{return writeErr(c,err)};if err:=h.service.RevokeAPIKey(c.Context(),c.Params("key_id"));err!=nil{return writeErr(c,err)};return c.SendStatus(fiber.StatusNoContent)}
func(h *DeveloperHandler)ListWebhooks(c *fiber.Ctx)error{if err:=h.requireAppOwner(c,c.Params("app_id"));err!=nil{return writeErr(c,err)};wh,err:=h.service.ListWebhooks(c.Context(),c.Params("app_id"));if err!=nil{return writeErr(c,err)};for _,w:=range wh{w.Secret=""};return c.JSON(fiber.Map{"webhooks":wh})}
func(h *DeveloperHandler)GetWebhook(c *fiber.Ctx)error{if err:=h.requireWebhookOwner(c,c.Params("webhook_id"));err!=nil{return writeErr(c,err)};wh,err:=h.service.GetWebhook(c.Context(),c.Params("webhook_id"));if err!=nil{return writeErr(c,err)};if wh!=nil{wh.Secret=""};return c.JSON(wh)}
func(h *DeveloperHandler)CreateWebhook(c *fiber.Ctx)error{if err:=h.requireAppOwner(c,c.Params("app_id"));err!=nil{return writeErr(c,err)};var req struct{Name string `json:"name"`;URL string `json:"url"`;Events []string `json:"events"`};if err:=c.BodyParser(&req);err!=nil{return writeErr(c,err)};wh,err:=h.service.CreateWebhook(c.Context(),c.Params("app_id"),req.Name,req.URL,req.Events);if err!=nil{return writeErr(c,err)};return c.Status(fiber.StatusCreated).JSON(wh)}
func(h *DeveloperHandler)UpdateWebhook(c *fiber.Ctx)error{if err:=h.requireWebhookOwner(c,c.Params("webhook_id"));err!=nil{return writeErr(c,err)};var wh domain.Webhook;if err:=c.BodyParser(&wh);err!=nil{return writeErr(c,err)};wh.ID=c.Params("webhook_id");if err:=h.service.UpdateWebhook(c.Context(),&wh);err!=nil{return writeErr(c,err)};wh.Secret="";return c.JSON(wh)}
func(h *DeveloperHandler)DeleteWebhook(c *fiber.Ctx)error{if err:=h.requireWebhookOwner(c,c.Params("webhook_id"));err!=nil{return writeErr(c,err)};if err:=h.service.DeleteWebhook(c.Context(),c.Params("webhook_id"));err!=nil{return writeErr(c,err)};return c.SendStatus(fiber.StatusNoContent)}
func(h *DeveloperHandler)TestWebhook(c *fiber.Ctx)error{if err:=h.requireWebhookOwner(c,c.Params("webhook_id"));err!=nil{return writeErr(c,err)};if err:=h.service.TestWebhook(c.Context(),c.Params("webhook_id"));err!=nil{return writeErr(c,err)};return c.SendStatus(fiber.StatusNoContent)}
func(h *DeveloperHandler)ListBots(c *fiber.Ctx)error{if err:=h.requireAppOwner(c,c.Params("app_id"));err!=nil{return writeErr(c,err)};bots,err:=h.service.ListBots(c.Context(),c.Params("app_id"));if err!=nil{return writeErr(c,err)};return c.JSON(bots)}
func(h *DeveloperHandler)GetBot(c *fiber.Ctx)error{if err:=h.requireBotOwner(c,c.Params("bot_id"));err!=nil{return writeErr(c,err)};bot,err:=h.service.GetBot(c.Context(),c.Params("bot_id"));if err!=nil{return writeErr(c,err)};return c.JSON(bot)}
func(h *DeveloperHandler)CreateBot(c *fiber.Ctx)error{if err:=h.requireAppOwner(c,c.Params("app_id"));err!=nil{return writeErr(c,err)};var req struct{Name string `json:"name"`;Description string `json:"description"`};if err:=c.BodyParser(&req);err!=nil{return writeErr(c,err)};bot,err:=h.service.CreateBot(c.Context(),c.Params("app_id"),req.Name,req.Description);if err!=nil{return writeErr(c,err)};return c.Status(fiber.StatusCreated).JSON(bot)}
func(h *DeveloperHandler)UpdateBot(c *fiber.Ctx)error{if err:=h.requireBotOwner(c,c.Params("bot_id"));err!=nil{return writeErr(c,err)};var bot domain.Bot;if err:=c.BodyParser(&bot);err!=nil{return writeErr(c,err)};bot.ID=c.Params("bot_id");if err:=h.service.UpdateBot(c.Context(),&bot);err!=nil{return writeErr(c,err)};return c.JSON(bot)}
func(h *DeveloperHandler)DeleteBot(c *fiber.Ctx)error{if err:=h.requireBotOwner(c,c.Params("bot_id"));err!=nil{return writeErr(c,err)};if err:=h.service.DeleteBot(c.Context(),c.Params("bot_id"));err!=nil{return writeErr(c,err)};return c.SendStatus(fiber.StatusNoContent)}
func(h *DeveloperHandler)GetMetrics(c *fiber.Ctx)error{if err:=h.requireAppOwner(c,c.Params("app_id"));err!=nil{return writeErr(c,err)};period:=c.Query("period","24h");m,err:=h.service.GetMetrics(c.Context(),c.Params("app_id"),period);if err!=nil{return writeErr(c,err)};return c.JSON(m)}
func(h *DeveloperHandler)TestSuite(c *fiber.Ctx)error{if err:=h.requireAppOwner(c,c.Params("app_id"));err!=nil{return writeErr(c,err)};r,err:=h.service.RunTestSuite(c.Context(),c.Params("app_id"));if err!=nil{return writeErr(c,err)};return c.JSON(r)}
