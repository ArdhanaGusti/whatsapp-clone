package models

import "gorm.io/gorm"

type Message struct {
	gorm.Model
	Message    string
	SenderID   uint
	Sender     User `gorm:"foreignKey:SenderID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	ReceiverID uint
	Receiver   User `gorm:"foreignKey:ReceiverID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}
