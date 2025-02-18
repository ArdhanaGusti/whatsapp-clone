package payload

type LoginUserPayload struct {
	Email    string `json:"Email" form:"Email" binding:"required,email"`
	Password string `json:"Password" form:"Password" binding:"required"`
}
