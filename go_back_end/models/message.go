package models

import "gorm.io/gorm"

type Message struct {
	gorm.Model
	Message    string
	SenderID   uint
	ReceiverID uint
	Sender     User `gorm:"foreignKey:SenderID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	Receiver   User `gorm:"foreignKey:ReceiverID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}
