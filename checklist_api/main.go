package main

import (
	"checklist/checklist_api/config"
	"checklist/checklist_api/handler"
	"checklist/checklist_api/service"
	"checklist/checklist_api/util"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()
	router.SetTrustedProxies(nil)
	router.Use(util.HeaderMiddleware())

	as := service.NewAuthService(config.DB)
	ah := handler.NewAuthHandler(as)
	auth := router.Group("/auth")
	auth.POST("/register", ah.HandleRegister)
	auth.POST("/login", ah.HandleLogin)

	router.Use(util.AuthMiddleware(config.DB))
	router.GET("/logout", ah.HandleLogout)

	router.Run(":8080")
}
