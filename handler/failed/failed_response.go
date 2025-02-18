package failed

type FailedResponse struct {
	StatusCode int    `json:"status_code"`
	Message    string `json:"message"`
}
