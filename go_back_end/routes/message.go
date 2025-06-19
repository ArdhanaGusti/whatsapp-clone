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
	query := `
		SELECT m.id
			,m.message
			,m.sender_id
			,m.receiver_id
			,s.username as sender_name
			,r.username as receiver_name
		FROM messages m
		LEFT JOIN users s
			ON s.id = m.sender_id
		LEFT JOIN users r
			ON r.id = m.receiver_id
		WHERE m.sender_id = ? OR m.receiver_id = ?
		`
	if err := config.DB.Raw(query, userId, userId).Scan(&allMessages).Error; err != nil {
		c.JSON(400, failed.FailedResponse{
			StatusCode: 400,
			Message:    "Error get messages:" + err.Error(),
		})
	}

	c.JSON(200, allMessages)
}
