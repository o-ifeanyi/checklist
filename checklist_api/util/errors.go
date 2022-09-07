package util

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type ErrResponse struct {
	StatusCode uint16 `json:"status_code,omitempty"`
	Message    string `json:"message,omitempty"`
	ErrorText  string `json:"error,omitempty"`
}

func BadRequest(c *gin.Context, err error) {
	e := ErrResponse{
		StatusCode: http.StatusBadRequest,
		ErrorText:  "Bad Request",
		Message:    err.Error(),
	}
	c.AbortWithStatusJSON(http.StatusBadRequest, e)
}

func UnprocessableEntity(c *gin.Context, err error) {
	e := ErrResponse{
		StatusCode: http.StatusUnprocessableEntity,
		ErrorText:  "Unprocessable Entity",
		Message:    err.Error(),
	}
	c.AbortWithStatusJSON(http.StatusUnprocessableEntity, e)
}

func InternalServerError(c *gin.Context, err error) {
	e := ErrResponse{
		StatusCode: http.StatusInternalServerError,
		ErrorText:  "Internal Server Error",
		Message:    err.Error(),
	}
	c.AbortWithStatusJSON(http.StatusInternalServerError, e)
}

func Unauthorized(c *gin.Context, err error) {
	e := ErrResponse{
		StatusCode: http.StatusUnauthorized,
		ErrorText:  "Unauthorized",
		Message:    err.Error(),
	}
	c.AbortWithStatusJSON(http.StatusUnauthorized, e)
}

func Forbidden(c *gin.Context, err error) {
	e := ErrResponse{
		StatusCode: http.StatusForbidden,
		ErrorText:  "Forbidden",
		Message:    err.Error(),
	}
	c.AbortWithStatusJSON(http.StatusForbidden, e)
}

func NotFound(c *gin.Context, err error) {
	e := ErrResponse{
		StatusCode: http.StatusNotFound,
		ErrorText:  "Not Found",
		Message:    err.Error(),
	}
	c.AbortWithStatusJSON(http.StatusNotFound, e)
}
