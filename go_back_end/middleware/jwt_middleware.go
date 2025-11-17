package middleware

import (
	"fmt"
	"os"
	"strings"
	"whatsapp-clone/go_back_end/handler/failed"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

func IsAuth() gin.HandlerFunc {
	return CheckJwt(false)
}

func IsAdmin() gin.HandlerFunc {
	return CheckJwt(true)
}

func CheckJwt(admin bool) gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.Request.Header.Get("Authorization")
		bearerToken := strings.Split(authHeader, " ")
		token, err := jwt.Parse(bearerToken[1], func(token *jwt.Token) (interface{}, error) {
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
			}

			return []byte(os.Getenv("JWT_SECRET")), nil
		})

		if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
			c.Set("jwt_user_id", claims["user_id"])

			if admin == true {
				c.JSON(403, failed.FailedResponse{
					StatusCode: 403,
					Message:    "You're not an admin",
				})
				c.Abort()
				return
			}
		} else {
			c.JSON(422, failed.FailedResponse{
				StatusCode: 422,
				Message:    err.Error(),
			})
			c.Abort()
			return
		}
	}
}
