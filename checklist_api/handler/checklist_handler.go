package handler

import (
	inter "checklist/checklist_api/interface"
	"checklist/checklist_api/model"
	"checklist/checklist_api/util"
	"encoding/json"
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
)

type syncReqParam struct {
	Data []model.Checklist `json:"data,omitempty"`
}

type ChecklistHandler struct {
	CI inter.ChecklistInterface
}

func NewChecklistHandler(CI inter.ChecklistInterface) ChecklistHandler {
	return ChecklistHandler{CI: CI}
}

func (ch ChecklistHandler) HandleSync(c *gin.Context) {
	userId := c.GetString("userid")
	param := syncReqParam{}
	err := json.NewDecoder(c.Request.Body).Decode(&param)
	if err != nil {
		util.InternalServerError(c, errors.New("error decoding form"))
		return
	}

	for i := range param.Data {
		param.Data[i].UserId = userId
	}

	res, err := ch.CI.Sync(param.Data)
	if err != nil {
		util.InternalServerError(c, err)
		return
	}

	c.JSON(http.StatusOK, model.Response{
		Status:  http.StatusOK,
		Message: "success",
		Data:    res,
	})
}

func (ch ChecklistHandler) HandleCreate(c *gin.Context) {
	userId := c.GetString("userid")
	cl := model.Checklist{}
	err := json.NewDecoder(c.Request.Body).Decode(&cl)
	if err != nil {
		util.InternalServerError(c, errors.New("error decoding form"))
		return
	}
	cl.UserId = userId

	err = ch.CI.Create(cl)
	if err != nil {
		util.InternalServerError(c, err)
		return
	}

	c.JSON(http.StatusCreated, model.Response{
		Status:  http.StatusCreated,
		Message: "success",
	})
}

func (ch ChecklistHandler) HandleUpdate(c *gin.Context) {
	userId := c.GetString("userid")
	cl := model.Checklist{}
	err := json.NewDecoder(c.Request.Body).Decode(&cl)
	if err != nil {
		util.InternalServerError(c, errors.New("error decoding form"))
		return
	}
	cl.UserId = userId

	err = ch.CI.Update(cl)
	if err != nil {
		util.InternalServerError(c, err)
		return
	}

	c.JSON(http.StatusOK, model.Response{
		Status:  http.StatusOK,
		Message: "success",
	})
}

func (ch ChecklistHandler) HandleDelete(c *gin.Context) {
	id := c.Param("id")
	err := ch.CI.Delete(id)
	if err != nil {
		util.InternalServerError(c, err)
		return
	}

	c.JSON(http.StatusOK, model.Response{
		Status:  http.StatusOK,
		Message: "success",
	})
}
