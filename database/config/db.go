package config

import (
	"fmt"
	"os"

	"github.com/ArdhanaGusti/go-socket/models"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var DB *gorm.DB

func InitDB() {
	var err error
	username := os.Getenv("DB_USERNAME")
	password := os.Getenv("DB_PASSWORD")
	host := os.Getenv("DB_HOST")
	port := os.Getenv("DB_PORT")
	dbname := os.Getenv("DB_NAME")

	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
		username, password, host, port, dbname)
	DB, err = gorm.Open(mysql.Open(dsn), &gorm.Config{})

	if err != nil {
		panic("Failed to connect")
	}
	// defer db.DB()

	DB.AutoMigrate(&models.User{}, &models.Message{})
}

func MigrateFreshDB() {
	DB.Migrator().DropTable(&models.User{}, &models.Message{})
	DB.AutoMigrate(&models.User{}, &models.Message{})
}
