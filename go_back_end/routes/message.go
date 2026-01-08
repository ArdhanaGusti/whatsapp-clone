package routes

import (
	"fmt"
	"net/http"

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
				fmt.Println("Error send response:", erw)
				delete(clients, conn)
				break
			}
		}
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
