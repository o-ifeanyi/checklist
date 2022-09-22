package main

import (
	"checklist/checklist_api/config"
	"checklist/checklist_api/handler"
	"checklist/checklist_api/service"
	"checklist/checklist_api/util"
	"os"

	"github.com/gin-gonic/gin"
)

func main() {
	port := os.Getenv("PORT")

	router := gin.Default()
	router.SetTrustedProxies(nil)
	router.Use(util.HeaderMiddleware())

	ms := service.NewMongoService(config.DB)
	ah := handler.NewAuthHandler(service.NewAuthService(ms))
	auth := router.Group("/auth")
	auth.POST("/register", ah.HandleRegister)
	auth.POST("/login", ah.HandleLogin)

	ch := handler.NewChecklistHandler(service.NewChecklistService(ms))
	user := router.Group("/user")
	user.Use(util.AuthMiddleware())
	user.GET("/logout", ah.HandleLogout)
	user.POST("/sync", ch.HandleSync)
	user.POST("/create", ch.HandleCreate)
	user.POST("/update", ch.HandleUpdate)
	user.DELETE("/delete", ch.HandleDelete)
	user.DELETE("/account/delete", ah.HandleDelete)

	router.Run(port)
}
