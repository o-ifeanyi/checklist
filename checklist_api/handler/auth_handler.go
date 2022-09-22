package handler

import (
	inter "checklist/checklist_api/interface"
	"checklist/checklist_api/model"
	"checklist/checklist_api/util"
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
)

type AuthHandler struct {
	AI inter.AuthInterface
}

type regParam struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

func NewAuthHandler(AI inter.AuthInterface) AuthHandler {
	return AuthHandler{AI: AI}
}

func (ah AuthHandler) HandleRegister(c *gin.Context) {
	rp := regParam{}
	err := c.ShouldBindJSON(&rp)
	if err != nil {
		util.InternalServerError(c, errors.New("error decoding form"))
		return
	}

	token, err := ah.AI.Create(rp.Email, rp.Password)
	if err != nil {
		util.InternalServerError(c, err)
		return
	}

	c.Header("Token", token)
	c.Header("Access-Control-Expose-Headers", "Token")
	c.JSON(http.StatusCreated, model.Response{
		Status:  http.StatusCreated,
		Message: "success",
	})
}

func (ah AuthHandler) HandleLogin(c *gin.Context) {
	rp := regParam{}
	err := c.ShouldBindJSON(&rp)
	if err != nil {
		util.InternalServerError(c, errors.New("error decoding form"))
		return
	}

	token, err := ah.AI.Login(rp.Email, rp.Password)
	if err != nil {
		util.InternalServerError(c, err)
		return
	}

	c.Header("Token", token)
	c.Header("Access-Control-Expose-Headers", "Token")
	c.JSON(http.StatusOK, model.Response{
		Status:  http.StatusOK,
		Message: "success",
	})
}

func (ah AuthHandler) HandleLogout(c *gin.Context) {
	userId := c.GetString("userid")

	err := ah.AI.Logout(userId)
	if err != nil {
		util.InternalServerError(c, err)
		return
	}

	c.JSON(http.StatusOK, model.Response{
		Status:  http.StatusOK,
		Message: "success",
	})
}

func (ah AuthHandler) HandleDelete(c *gin.Context) {
	userId := c.GetString("userid")

	err := ah.AI.Delete(userId)
	if err != nil {
		util.InternalServerError(c, err)
		return
	}

	c.JSON(http.StatusOK, model.Response{
		Status:  http.StatusOK,
		Message: "success",
	})
}
