package response

import "time"

type AllMessageResponse struct {
	Message      string    `json:"message"`
	OppositeName string    `json:"opposite_name"`
	IsSender     bool      `json:"is_sender"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
	DeletedAt    time.Time `json:"deleted_at"`
}
