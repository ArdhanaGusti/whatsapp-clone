package response

import "time"

type AllMessageResponse struct {
	Id           uint      `json:"id"`
	Message      string    `json:"message"`
	OppositeName string    `json:"opposite_name"`
	OppositeId   int       `json:"opposite_id"`
	IsSender     bool      `json:"is_sender"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
	DeletedAt    time.Time `json:"deleted_at"`
}
