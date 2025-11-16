package main

import (
	"fmt"

	"whatsapp-clone/go_back_end/database/config"
	"whatsapp-clone/go_back_end/routes"

	"github.com/gin-gonic/gin"
	"github.com/subosito/gotenv"
)

func setupRouter() *gin.Engine {
	r := gin.Default()

	r.GET("/ws", routes.HandleConnections)

	v1 := r.Group("/api/v1")
	{
		v2 := v1.Group("/auth")
		{
			v2.POST("/register", routes.RegisterUser)
			v2.POST("/login", routes.LoginUser)
		}
		v3 := v1.Group("/message")
		{
			v3.GET("/", routes.GetMessageHeader)
			v3.GET("/detail", routes.GetMessageHeader)
		}
	}

	return r
}

func main() {
	gotenv.Load()
	config.InitDB()

	r := setupRouter()

	fmt.Println("Gin WebSocket server running on :8080")
	r.Run(":8080")
}
