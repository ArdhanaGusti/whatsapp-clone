package routes

import (
	"fmt"
	"net/http"

	"github.com/ArdhanaGusti/go_back_end/database/config"
	"github.com/ArdhanaGusti/go_back_end/handler/failed"
	"github.com/ArdhanaGusti/go_back_end/handler/response"
	"github.com/ArdhanaGusti/go_back_end/models"
	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
	"gorm.io/gorm"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

var clients = make(map[*websocket.Conn]bool)

// var broadcast = make(chan models.Message)

func HandleConnections(c *gin.Context) {
	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		fmt.Println("WebSocket Upgrade Error:", err)
		return
	}
	defer conn.Close()
	clients[conn] = true

	for {
		var msg models.Message
		err := conn.ReadJSON(&msg)
		if err != nil {
			fmt.Println("Error reading JSON:", err)
			delete(clients, conn)
			break
		}

		if err := config.DB.Create(&msg).Error; err != nil {
			fmt.Println("Error save message:", err)
			delete(clients, conn)
			break
		} else {
			erw := conn.WriteMessage(websocket.TextMessage, []byte("Successfully create message"))
			if erw != nil {
				fmt.Println("Error writing JSON:", erw)
				delete(clients, conn)
				break
			}
		}
	}
}

func GetMessage(c *gin.Context) {
	userId := c.Query("userId")
	var allMessages []response.AllMessageResponse
	// var allMessages []models.Message
	if err := config.DB.Model(&models.Message{}).Preload("Sender", func(db *gorm.DB) *gorm.DB {
		return db.Select("id, username")
	}).Preload("Receiver", func(db *gorm.DB) *gorm.DB {
		return db.Select("id, username")
	}).Where("sender_id = ? ", userId).Or("receiver_id = ? ", userId).Find(&allMessages).Error; err != nil {
		c.JSON(404, failed.FailedResponse{
			StatusCode: 404,
			Message:    "Message don't exist",
		})
		c.Abort()
		return
	}

	c.JSON(200, allMessages)
}
