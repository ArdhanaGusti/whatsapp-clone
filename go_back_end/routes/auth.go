package routes

import (
	"os"
	"time"

	"github.com/ArdhanaGusti/go_back_end/database/config"
	"github.com/ArdhanaGusti/go_back_end/handler/failed"
	"github.com/ArdhanaGusti/go_back_end/handler/payload"
	"github.com/ArdhanaGusti/go_back_end/models"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
)

func RegisterUser(c *gin.Context) {
	var userInput models.User

	if err := c.ShouldBind(&userInput); err != nil {
		c.JSON(400, failed.FailedResponse{
			StatusCode: 400,
			Message:    err.Error(),
		})
		return
	}

	var existedUser models.User
	if err := config.DB.First(&existedUser, "email = ?", userInput.Email).Error; err == nil {
		c.JSON(409, failed.FailedResponse{
			StatusCode: 409,
			Message:    "User is exist",
		})
		c.Abort()
		return
	}

	hash, err := bcrypt.GenerateFromPassword([]byte(userInput.Password), bcrypt.DefaultCost)
	if err != nil {
		c.JSON(400, failed.FailedResponse{
			StatusCode: 400,
			Message:    "Hashing is failed",
		})
		c.Abort()
		return
	}

	newUser := models.User{
		Username: userInput.Username,
		Email:    userInput.Email,
		Password: string(hash),
	}

	if err := config.DB.Create(&newUser).Error; err != nil {
		c.JSON(500, failed.FailedResponse{
			StatusCode: 500,
			Message:    err.Error(),
		})
		c.Abort()
		return
	}

	c.JSON(200, gin.H{
		"status": "User " + userInput.Username + " Registered Successfully",
	})
}

func LoginUser(c *gin.Context) {
	var userInput payload.LoginUserPayload

	if err := c.ShouldBind(&userInput); err != nil {
		c.JSON(400, failed.FailedResponse{
			StatusCode: 400,
			Message:    err.Error(),
		})
		return
	}

	var existedUser models.User
	if err := config.DB.First(&existedUser, "email = ?", userInput.Email).Error; err != nil {
		c.JSON(404, failed.FailedResponse{
			StatusCode: 404,
			Message:    "User don't exist",
		})
		c.Abort()
		return
	}

	if err := bcrypt.CompareHashAndPassword([]byte(existedUser.Password), []byte(userInput.Password)); err != nil {
		c.JSON(400, failed.FailedResponse{
			StatusCode: 400,
			Message:    err.Error(),
		})
		c.Abort()
		return
	}

	jwtToken, ert := getToken(&existedUser)
	if ert != nil {
		c.JSON(500, failed.FailedResponse{
			StatusCode: 500,
			Message:    ert.Error(),
		})
		c.Abort()
		return
	}
	c.JSON(200, gin.H{
		"token":   jwtToken,
		"message": "Login " + existedUser.Username + " Successfully",
	})
}

func getToken(user *models.User) (string, error) {
	newToken := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id":   user.ID,
		"user_name": user.Username,
		"exp":       time.Now().AddDate(0, 0, 7).Unix(),
		"iat":       time.Now().Unix(),
	})

	tokenString, err := newToken.SignedString([]byte(os.Getenv("JWT_SECRET")))
	if err != nil {
		return "", err
	}

	return tokenString, nil
}
