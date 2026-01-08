package response

import "time"

type DetailMessageResponse struct {
	Id        uint      `json:"id"`
	Message   string    `json:"message"`
	IsMe      bool      `json:"is_me"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
	DeletedAt time.Time `json:"deleted_at"`
}
