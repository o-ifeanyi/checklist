package util

import (
	"checklist/checklist_api/model"
	"net/http"

	"github.com/gin-gonic/gin"
)

func BadRequest(c *gin.Context, err error) {
	e := model.Response{
		Status:  http.StatusBadRequest,
		Message: err.Error(),
	}
	c.AbortWithStatusJSON(http.StatusBadRequest, e)
}

func UnprocessableEntity(c *gin.Context, err error) {
	e := model.Response{
		Status:  http.StatusUnprocessableEntity,
		Message: err.Error(),
	}
	c.AbortWithStatusJSON(http.StatusUnprocessableEntity, e)
}

func InternalServerError(c *gin.Context, err error) {
	e := model.Response{
		Status:  http.StatusInternalServerError,
		Message: err.Error(),
	}
	c.AbortWithStatusJSON(http.StatusInternalServerError, e)
}

func Unauthorized(c *gin.Context, err error) {
	e := model.Response{
		Status:  http.StatusUnauthorized,
		Message: err.Error(),
	}
	c.AbortWithStatusJSON(http.StatusUnauthorized, e)
}

func Forbidden(c *gin.Context, err error) {
	e := model.Response{
		Status:  http.StatusForbidden,
		Message: err.Error(),
	}
	c.AbortWithStatusJSON(http.StatusForbidden, e)
}

func NotFound(c *gin.Context, err error) {
	e := model.Response{
		Status:  http.StatusNotFound,
		Message: err.Error(),
	}
	c.AbortWithStatusJSON(http.StatusNotFound, e)
}
