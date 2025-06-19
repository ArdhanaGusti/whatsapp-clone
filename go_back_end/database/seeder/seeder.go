package seeder

import (
	"fmt"
	"math/rand"
	"strings"

	"github.com/ArdhanaGusti/go_back_end/database/config"
	"github.com/ArdhanaGusti/go_back_end/models"
	"golang.org/x/crypto/bcrypt"
)

var letters = []rune("abcdefghijklmnopqrstuvwxyz0123456789")

func randomString(n int) string {
	sb := strings.Builder{}
	for i := 0; i < n; i++ {
		sb.WriteRune(letters[rand.Intn(len(letters))])
	}
	return sb.String()
}

func generateRandomUsernameEmail() (string, string) {
	username := randomString(8)
	domains := []string{"example.com", "mail.com", "test.org", "go.dev"}
	email := fmt.Sprintf("%s@%s", username, domains[rand.Intn(len(domains))])
	return username, email
}

func SeedDatabase() {
	hash, _ := bcrypt.GenerateFromPassword([]byte("admin123"), bcrypt.DefaultCost)
	var users []models.User
	var messages []models.Message

	for i := 0; i < 10; i++ {
		username, email := generateRandomUsernameEmail()
		users = append(users, models.User{Username: username, Email: email, Password: string(hash)})
	}

	if err := config.DB.Create(&users).Error; err != nil {
		fmt.Println("Error seeding user:", err)
	}

	for i := 1; i <= 100000; i++ {
		message := randomString(20)
		sender := rand.Intn(10) + 1
		receiver := rand.Intn(10) + 1
		messages = append(messages, models.Message{Message: message, SenderID: uint(sender), ReceiverID: uint(receiver)})

		if i%10000 == 0 && i > 0 {
			if err := config.DB.Create(&messages).Error; err != nil {
				fmt.Println("Error seeding message:", err)
				break
			}
			messages = []models.Message{}
		}
	}
}
