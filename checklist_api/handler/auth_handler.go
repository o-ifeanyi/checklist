package handler

import (
	inter "checklist/checklist_api/interface"
	"checklist/checklist_api/util"
	"encoding/json"
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
	err := json.NewDecoder(c.Request.Body).Decode(&rp)
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
	c.Header("Content-Type", "application/json")
	c.Header("Access-Control-Expose-Headers", "Token")
	c.String(http.StatusCreated, "%s\n", "registration successful")
}

func (ah AuthHandler) HandleLogin(c *gin.Context) {
	rp := regParam{}
	err := json.NewDecoder(c.Request.Body).Decode(&rp)
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
	c.Header("Content-Type", "application/json")
	c.Header("Access-Control-Expose-Headers", "Token")
	c.String(http.StatusOK, "%s", "login successful")
}

func (ah AuthHandler) HandleLogout(c *gin.Context) {
	userId := c.GetString("userid")

	err := ah.AI.Logout(userId)
	if err != nil {
		util.InternalServerError(c, err)
		return
	}

	c.Header("Content-Type", "application/json")
	c.Header("Access-Control-Expose-Headers", "Token")
	c.String(http.StatusOK, "%s", "logout successful")
}
