package util

import (
	"errors"

	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/mongo"
)

func AuthMiddleware(DB *mongo.Database) gin.HandlerFunc {
	return func(c *gin.Context) {
		tokenString := c.GetHeader("Authorization")
		if tokenString == "" {
			Forbidden(c, errors.New("malformed token, try loging in"))
			return
		}

		userID, err := ParseToken(tokenString)
		if err != nil {
			Unauthorized(c, errors.New("invalid token: "+err.Error()))
			return
		}
		c.Set("userid", userID)
		c.Next()
	}
}

func HeaderMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Methods", "GET,PUT,PATCH,POST,DELETE")
		c.Header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept")
		c.Next()
	}
}
