package main

import (
	"fmt"

	"github.com/ArdhanaGusti/go-socket/database/config"
	"github.com/ArdhanaGusti/go-socket/routes"
	"github.com/gin-gonic/gin"
	"github.com/subosito/gotenv"
)

func setupRouter() *gin.Engine {
	r := gin.Default()

	r.GET("/ws", routes.HandleConnections)

	v1 := r.Group("/api/v1")
	{
		v1.POST("/auth/register", routes.RegisterUser)
		v1.POST("/auth/login", routes.LoginUser)
	}

	return r
}

func main() {
	gotenv.Load()
	config.InitDB()

	// config.MigrateFreshDB()

	// seeder.SeedDatabase()

	r := setupRouter()

	fmt.Println("Gin WebSocket server running on :8080")
	r.Run(":8080")
}
