package handler

import (
	"bytes"
	"checklist/checklist_api/mock"
	"checklist/checklist_api/model"
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func TestHandleRegister(t *testing.T) {
	gin.SetMode(gin.TestMode)
	param := regParam{
		Email:    "ifeanyi@gmail.com",
		Password: "123456",
	}
	reqValue, _ := json.Marshal(param)
	t.Run("expect 201 on success", func(t *testing.T) {
		as := new(mock.AuthService)
		ah := NewAuthHandler(as)

		router := gin.Default()
		router.POST("auth/register", ah.HandleRegister)

		w := httptest.NewRecorder()
		req, _ := http.NewRequest("POST", "/auth/register", bytes.NewBuffer(reqValue))
		as.On("Create", param.Email, param.Password).Return("token", nil)
		router.ServeHTTP(w, req)
		exp := model.Response{
			Status:  http.StatusCreated,
			Message: "success",
		}
		expJson, _ := json.Marshal(exp)
		assert.Equal(t, "token", w.Header().Get("Token"))
		assert.Equal(t, exp.Status, w.Code)
		assert.Equal(t, expJson, w.Body.Bytes())
	})

	t.Run("expect 500 on error", func(t *testing.T) {
		as := new(mock.AuthService)
		ah := NewAuthHandler(as)

		router := gin.Default()
		router.POST("auth/register", ah.HandleRegister)
		w := httptest.NewRecorder()
		req, _ := http.NewRequest("POST", "/auth/register", bytes.NewBuffer(reqValue))
		as.On("Create", param.Email, param.Password).Return("", errors.New("failed"))
		router.ServeHTTP(w, req)
		exp := model.Response{
			Status:  http.StatusInternalServerError,
			Message: "failed",
		}
		expJson, _ := json.Marshal(exp)
		assert.Equal(t, exp.Status, w.Code)
		assert.Equal(t, expJson, w.Body.Bytes())
	})
}

func TestHandleLogin(t *testing.T) {
	gin.SetMode(gin.TestMode)
	param := regParam{
		Email:    "ifeanyi@gmail.com",
		Password: "123456",
	}
	reqValue, _ := json.Marshal(param)

	t.Run("expect 200 on success", func(t *testing.T) {
		as := new(mock.AuthService)
		as.On("Login", param.Email, param.Password).Return("token", nil)
		ah := NewAuthHandler(as)

		router := gin.Default()
		router.POST("auth/login", ah.HandleLogin)

		w := httptest.NewRecorder()
		req, _ := http.NewRequest("POST", "/auth/login", bytes.NewBuffer(reqValue))
		router.ServeHTTP(w, req)

		exp := model.Response{
			Status:  http.StatusOK,
			Message: "success",
		}
		expJson, _ := json.Marshal(exp)
		assert.Equal(t, "token", w.Header().Get("Token"))
		assert.Equal(t, exp.Status, w.Code)
		assert.Equal(t, expJson, w.Body.Bytes())
	})

	t.Run("expect 500 on error", func(t *testing.T) {
		as := new(mock.AuthService)
		as.On("Login", param.Email, param.Password).Return("", errors.New("failed"))
		ah := NewAuthHandler(as)

		router := gin.Default()
		router.POST("auth/login", ah.HandleLogin)

		w := httptest.NewRecorder()
		req, _ := http.NewRequest("POST", "/auth/login", bytes.NewBuffer(reqValue))
		router.ServeHTTP(w, req)

		exp := model.Response{
			Status:  http.StatusInternalServerError,
			Message: "failed",
		}
		expJson, _ := json.Marshal(exp)
		assert.Equal(t, exp.Status, w.Code)
		assert.Equal(t, expJson, w.Body.Bytes())
	})
}

func TestHandleLogout(t *testing.T) {
	gin.SetMode(gin.TestMode)

	t.Run("expect 200 on success", func(t *testing.T) {
		as := new(mock.AuthService)
		as.On("Logout", "").Return(nil)
		ah := NewAuthHandler(as)

		router := gin.Default()
		router.GET("user/logout", ah.HandleLogout)

		w := httptest.NewRecorder()
		req, _ := http.NewRequest("GET", "/user/logout", nil)
		router.ServeHTTP(w, req)

		exp := model.Response{
			Status:  http.StatusOK,
			Message: "success",
		}
		expJson, _ := json.Marshal(exp)
		assert.Equal(t, "", w.Header().Get("Token"))
		assert.Equal(t, exp.Status, w.Code)
		assert.Equal(t, expJson, w.Body.Bytes())
	})

	t.Run("expect 500 on error", func(t *testing.T) {
		as := new(mock.AuthService)
		as.On("Logout", "").Return(errors.New("failed"))
		ah := NewAuthHandler(as)

		router := gin.Default()
		router.GET("user/logout", ah.HandleLogout)

		w := httptest.NewRecorder()
		req, _ := http.NewRequest("GET", "/user/logout", nil)
		router.ServeHTTP(w, req)

		exp := model.Response{
			Status:  http.StatusInternalServerError,
			Message: "failed",
		}
		expJson, _ := json.Marshal(exp)
		assert.Equal(t, exp.Status, w.Code)
		assert.Equal(t, expJson, w.Body.Bytes())
	})
}
