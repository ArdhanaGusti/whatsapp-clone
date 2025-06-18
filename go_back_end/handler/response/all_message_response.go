package response

type AllMessageResponse struct {
	Message    string
	SenderID   uint
	ReceiverID uint
	Sender     User `gorm:"foreignKey:SenderID;references:ID"`
	Receiver   User `gorm:"foreignKey:ReceiverID;references:ID"`
}

type User struct {
	ID       uint
	Username string
}
