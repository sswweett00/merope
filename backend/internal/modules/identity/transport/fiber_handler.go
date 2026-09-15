package transport

import (
	"net/mail"
	"strings"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/redis/go-redis/v9"
	"local/merope/internal/core/errors"
	"local/merope/internal/core/security"
	"local/merope/internal/modules/identity/domain"
)

type IdentityHandler struct { service domain.IdentityService; jwtSecret string; rdb *redis.Client }
func NewIdentityHandler(service domain.IdentityService, jwtSecret string, rdb *redis.Client) *IdentityHandler { return &IdentityHandler{service:service,jwtSecret:jwtSecret,rdb:rdb} }

func (h *IdentityHandler) Register(c *fiber.Ctx) error {
	type request struct { Username string `json:"username"`; Email string `json:"email"`; Password string `json:"password"`; DisplayName string `json:"display_name"`; Type string `json:"type"` }
	var req request
	if err:=c.BodyParser(&req); err!=nil { return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code":errors.ErrBadRequest,"message":"Invalid request body"}) }
	sys:=domain.SystemPersonal; if strings.ToUpper(req.Type)=="CORPORATE" { sys=domain.SystemCorporate }
	req.Username=security.SanitizeHTML(req.Username); req.DisplayName=security.SanitizeHTML(req.DisplayName)
	if len(req.Username)<3 { return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code":errors.ErrValidation,"message":"Username too short"}) }
	if _,err:=mail.ParseAddress(req.Email); err!=nil { return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code":errors.ErrValidation,"message":"Invalid email format"}) }
	if len(req.Password)<8 { return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code":errors.ErrValidation,"message":"Password must be at least 8 characters"}) }
	user,token,err:=h.service.Register(c.Context(),req.Username,req.Email,req.Password,c.IP(),c.Get("User-Agent"),sys)
	if err!=nil { return c.Status(errors.ToHTTPStatus(err)).JSON(fiber.Map{"code":errors.GetCode(err),"message":err.Error()}) }
	if req.DisplayName!="" { user.DisplayName=req.DisplayName }
	refreshToken,_:=security.GenerateRefreshToken(); _=security.StoreRefreshToken(c.Context(),h.rdb,user.ID,refreshToken,30*24*time.Hour)
	return c.Status(fiber.StatusCreated).JSON(fiber.Map{"user":user,"token":token,"refresh_token":refreshToken})
}

func (h *IdentityHandler) Login(c *fiber.Ctx) error {
	type request struct { Email string `json:"email"`; Password string `json:"password"`; Fingerprint string `json:"fingerprint"` }
	var req request; if err:=c.BodyParser(&req); err!=nil { return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code":errors.ErrBadRequest,"message":"Invalid request body"}) }
	req.Email=security.SanitizeHTML(req.Email)
	user,token,mfaRequired,err:=h.service.Login(c.Context(),req.Email,req.Password,req.Fingerprint,c.IP(),c.Get("User-Agent"))
	if err!=nil { status:=errors.ToHTTPStatus(err); if strings.Contains(err.Error(),"locked") { status=fiber.StatusLocked }; return c.Status(status).JSON(fiber.Map{"code":errors.GetCode(err),"message":err.Error()}) }
	if mfaRequired { return c.JSON(fiber.Map{"mfa_required":true,"user_id":user.ID}) }
	refreshToken,_:=security.GenerateRefreshToken(); _=security.StoreRefreshToken(c.Context(),h.rdb,user.ID,refreshToken,30*24*time.Hour)
	return c.JSON(fiber.Map{"user":user,"token":token,"refresh_token":refreshToken})
}

func (h *IdentityHandler) SetupMFA(c *fiber.Ctx) error { userID:=c.Locals("user_id").(string); secret,url,err:=h.service.SetupMFA(c.Context(),userID); if err!=nil{return c.Status(errors.ToHTTPStatus(err)).JSON(fiber.Map{"code":errors.GetCode(err),"message":err.Error()})}; return c.JSON(fiber.Map{"secret":secret,"url":url}) }
func (h *IdentityHandler) VerifyMFA(c *fiber.Ctx) error { type request struct{UserID string `json:"user_id"`; Code string `json:"code"`}; var req request; if err:=c.BodyParser(&req);err!=nil{return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"code":errors.ErrBadRequest,"message":"Invalid request"})}; userID:=req.UserID; if userID==""{userID=c.Locals("user_id").(string)}; valid,err:=h.service.VerifyMFA(c.Context(),userID,req.Code); if err!=nil{return c.Status(errors.ToHTTPStatus(err)).JSON(fiber.Map{"code":errors.GetCode(err),"message":err.Error()})}; if !valid{return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"code":errors.ErrAuthFailed,"message":"Invalid MFA code"})}; return c.JSON(fiber.Map{"success":true}) }
func (h *IdentityHandler) Export(c *fiber.Ctx) error { userID:=c.Locals("user_id").(string); data,err:=h.service.ExportData(c.Context(),userID); if err!=nil{return c.Status(errors.ToHTTPStatus(err)).JSON(fiber.Map{"code":errors.GetCode(err),"message":err.Error()})}; return c.JSON(data) }
func (h *IdentityHandler) Logout(c *fiber.Ctx) error { tokenID:=c.Locals("token_id").(string); expiration:=c.Locals("token_exp").(time.Time); if err:=h.service.Logout(c.Context(),tokenID,expiration);err!=nil{return c.Status(errors.ToHTTPStatus(err)).JSON(fiber.Map{"code":errors.GetCode(err),"message":"Failed to logout"})}; return c.JSON(fiber.Map{"message":"Logged out successfully"}) }
func (h *IdentityHandler) Me(c *fiber.Ctx) error { userID:=c.Locals("user_id").(string); data,err:=h.service.ExportData(c.Context(),userID); if err!=nil{return c.Status(errors.ToHTTPStatus(err)).JSON(fiber.Map{"code":errors.GetCode(err),"message":err.Error()})}; return c.JSON(data["user"]) }
func (h *IdentityHandler) RefreshToken(c *fiber.Ctx) error { type request struct{RefreshToken string `json:"refresh_token"`}; var req request; if err:=c.BodyParser(&req);err!=nil{return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error":"Invalid request"})}; if req.RefreshToken==""{return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error":"Refresh token is required"})}; token,newRefreshToken,err:=h.service.RefreshToken(c.Context(),req.RefreshToken); if err!=nil{return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"error":err.Error()})}; return c.JSON(fiber.Map{"token":token,"refresh_token":newRefreshToken}) }
func (h *IdentityHandler) PasskeyLogin(c *fiber.Ctx) error { return c.JSON(fiber.Map{"message":"Passkey validation endpoint ready. Integration with WebAuthn library required.","status":"experimental"}) }
