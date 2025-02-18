package seeder

import (
	"fmt"

	"github.com/ArdhanaGusti/go-socket/database/config"
	"github.com/ArdhanaGusti/go-socket/models"
	"golang.org/x/crypto/bcrypt"
)

func SeedDatabase() {
	hash, _ := bcrypt.GenerateFromPassword([]byte("admin123"), bcrypt.DefaultCost)
	users := []models.User{
		{Username: "Alice", Email: "alice@example.com", Password: string(hash)},
		{Username: "Bob", Email: "bob@example.com", Password: string(hash)},
		{Username: "Charlie", Email: "charlie@example.com", Password: string(hash)},
	}

	for _, user := range users {
		result := config.DB.Create(&user)
		if result.Error != nil {
			fmt.Println("Error seeding user:", result.Error)
		} else {
			fmt.Println("User seeded:", user.Username)
		}
	}
}
