package routes

import (
	"fmt"
	"net/http"

	"github.com/ArdhanaGusti/go-socket/database/config"
	"github.com/ArdhanaGusti/go-socket/models"
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
