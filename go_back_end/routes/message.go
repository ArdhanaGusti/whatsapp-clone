package routes

import (
	"encoding/json"
	"fmt"
	"net/http"
	"sync"

	"whatsapp-clone/go_back_end/database/config"
	"whatsapp-clone/go_back_end/handler/response"
	"whatsapp-clone/go_back_end/models"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

var (
	clients   = make(map[*websocket.Conn]bool)
	clientsMu sync.Mutex
	broadcast = make(chan models.Message)
)

func HandleConnections(c *gin.Context) {
	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		fmt.Println("WebSocket Upgrade Error:", err)
		return
	}

	clientsMu.Lock()
	clients[conn] = true
	clientsMu.Unlock()

	defer func() {
		clientsMu.Lock()
		delete(clients, conn)
		clientsMu.Unlock()
		conn.Close()
	}()

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
		}

		broadcast <- msg
	}
}

func HandleBroadcasts() {
	for msg := range broadcast {
		data, err := json.Marshal(msg)
		if err != nil {
			continue
		}

		clientsMu.Lock()
		for client := range clients {
			if err := client.WriteMessage(websocket.TextMessage, data); err != nil {
				fmt.Println("Write error:", err)
				client.Close()
				delete(clients, client)
			}
		}
		clientsMu.Unlock()
	}
}

func GetMessageHeader(c *gin.Context) {
	userId := uint(c.MustGet("jwt_user_id").(float64))
	var allMessages []response.AllMessageResponse

	if userId == 0 {
		c.JSON(400, "Missing user ID")
		return
	}

	if err := config.DB.Raw("CALL lastMessages(?);", userId).Scan(&allMessages).Error; err != nil {
		c.JSON(400, err.Error())
		return
	}

	c.JSON(200, allMessages)
}

func GetMessageDetails(c *gin.Context) {
	userId := uint(c.MustGet("jwt_user_id").(float64))
	oppositeId := c.Query("userId")
	var allMessages []response.DetailMessageResponse

	if userId == 0 {
		c.JSON(400, "Missing user ID")
		return
	}

	if err := config.DB.
		Model(models.Message{}).
		Select(`
			id,
			message,
			CASE
				WHEN sender_id = ? THEN 1
				ELSE 0
			END AS is_me,
			created_at,
			updated_at,
			deleted_at
		`, userId).
		Where("sender_id = ? AND receiver_id = ?", userId, oppositeId).Or("sender_id = ? AND receiver_id = ?", oppositeId, userId).
		Order("id DESC").Scan(&allMessages).Error; err != nil {
		c.JSON(400, err.Error())
		return
	}
	c.JSON(200, allMessages)
}
