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
	"github.com/stretchr/testify/require"
)

func TestHandleSync(t *testing.T) {
	gin.SetMode(gin.TestMode)
	param := syncReqParam{
		Data: []model.Checklist{{UserId: ""}},
	}
	reqValue, _ := json.Marshal(param)
	t.Run("expect 200 on success", func(t *testing.T) {
		cs := new(mock.ChecklistService)
		ch := NewChecklistHandler(cs)

		router := gin.Default()
		router.POST("user/sync", ch.HandleSync)

		w := httptest.NewRecorder()
		req, _ := http.NewRequest("POST", "/user/sync", bytes.NewBuffer(reqValue))
		cs.On("Sync", param.Data).Return(param.Data, nil)
		router.ServeHTTP(w, req)
		exp := model.Response{
			Status:  http.StatusOK,
			Message: "success",
			Data:    param.Data,
		}
		expJson, _ := json.Marshal(exp)
		require.Equal(t, exp.Status, w.Code)
		require.Equal(t, expJson, w.Body.Bytes())
	})

	t.Run("expect 500 on error", func(t *testing.T) {
		cs := new(mock.ChecklistService)
		ch := NewChecklistHandler(cs)

		router := gin.Default()
		router.POST("user/sync", ch.HandleSync)
		w := httptest.NewRecorder()
		req, _ := http.NewRequest("POST", "/user/sync", bytes.NewBuffer(reqValue))
		cs.On("Sync", param.Data).Return(param.Data, errors.New("failed"))
		router.ServeHTTP(w, req)
		exp := model.Response{
			Status:  http.StatusInternalServerError,
			Message: "failed",
		}
		expJson, _ := json.Marshal(exp)
		require.Equal(t, exp.Status, w.Code)
		require.Equal(t, expJson, w.Body.Bytes())
	})
}

func TestHandleCreate(t *testing.T) {
	gin.SetMode(gin.TestMode)
	param := model.Checklist{UserId: ""}

	reqValue, _ := json.Marshal(param)
	t.Run("expect 200 on success", func(t *testing.T) {
		cs := new(mock.ChecklistService)
		ch := NewChecklistHandler(cs)

		router := gin.Default()
		router.POST("user/create", ch.HandleCreate)

		w := httptest.NewRecorder()
		req, _ := http.NewRequest("POST", "/user/create", bytes.NewBuffer(reqValue))
		cs.On("Create", param).Return(nil)
		router.ServeHTTP(w, req)
		exp := model.Response{
			Status:  http.StatusCreated,
			Message: "success",
		}
		expJson, _ := json.Marshal(exp)
		require.Equal(t, exp.Status, w.Code)
		require.Equal(t, expJson, w.Body.Bytes())
	})

	t.Run("expect 500 on error", func(t *testing.T) {
		cs := new(mock.ChecklistService)
		ch := NewChecklistHandler(cs)

		router := gin.Default()
		router.POST("user/create", ch.HandleCreate)
		w := httptest.NewRecorder()
		req, _ := http.NewRequest("POST", "/user/create", bytes.NewBuffer(reqValue))
		cs.On("Create", param).Return(errors.New("failed"))
		router.ServeHTTP(w, req)
		exp := model.Response{
			Status:  http.StatusInternalServerError,
			Message: "failed",
		}
		expJson, _ := json.Marshal(exp)
		require.Equal(t, exp.Status, w.Code)
		require.Equal(t, expJson, w.Body.Bytes())
	})
}

func TestHandleUpdate(t *testing.T) {
	gin.SetMode(gin.TestMode)
	param := model.Checklist{UserId: ""}

	reqValue, _ := json.Marshal(param)
	t.Run("expect 200 on success", func(t *testing.T) {
		cs := new(mock.ChecklistService)
		ch := NewChecklistHandler(cs)

		router := gin.Default()
		router.POST("user/update", ch.HandleUpdate)

		w := httptest.NewRecorder()
		req, _ := http.NewRequest("POST", "/user/update", bytes.NewBuffer(reqValue))
		cs.On("Update", param).Return(nil)
		router.ServeHTTP(w, req)
		exp := model.Response{
			Status:  http.StatusOK,
			Message: "success",
		}
		expJson, _ := json.Marshal(exp)
		require.Equal(t, exp.Status, w.Code)
		require.Equal(t, expJson, w.Body.Bytes())
	})

	t.Run("expect 500 on error", func(t *testing.T) {
		cs := new(mock.ChecklistService)
		ch := NewChecklistHandler(cs)

		router := gin.Default()
		router.POST("user/update", ch.HandleUpdate)
		w := httptest.NewRecorder()
		req, _ := http.NewRequest("POST", "/user/update", bytes.NewBuffer(reqValue))
		cs.On("Update", param).Return(errors.New("failed"))
		router.ServeHTTP(w, req)
		exp := model.Response{
			Status:  http.StatusInternalServerError,
			Message: "failed",
		}
		expJson, _ := json.Marshal(exp)
		require.Equal(t, exp.Status, w.Code)
		require.Equal(t, expJson, w.Body.Bytes())
	})
}

func TestHandleDelete(t *testing.T) {
	gin.SetMode(gin.TestMode)
	param := syncReqParam{
		Data: []model.Checklist{{Id: "id"}},
	}
	reqValue, _ := json.Marshal(param)

	t.Run("expect 200 on success", func(t *testing.T) {
		cs := new(mock.ChecklistService)
		ch := NewChecklistHandler(cs)

		router := gin.Default()
		router.DELETE("user/delete", ch.HandleDelete)

		w := httptest.NewRecorder()
		req, _ := http.NewRequest("DELETE", "/user/delete", bytes.NewBuffer(reqValue))
		cs.On("Delete", "id").Return(nil)
		router.ServeHTTP(w, req)
		exp := model.Response{
			Status:  http.StatusOK,
			Message: "success",
		}
		expJson, _ := json.Marshal(exp)
		require.Equal(t, exp.Status, w.Code)
		require.Equal(t, expJson, w.Body.Bytes())
	})

	t.Run("expect 500 on error", func(t *testing.T) {
		cs := new(mock.ChecklistService)
		ch := NewChecklistHandler(cs)

		router := gin.Default()
		router.DELETE("user/delete", ch.HandleDelete)
		w := httptest.NewRecorder()
		req, _ := http.NewRequest("DELETE", "/user/delete", bytes.NewBuffer(reqValue))
		cs.On("Delete", "id").Return(errors.New("failed"))
		router.ServeHTTP(w, req)
		exp := model.Response{
			Status:  http.StatusInternalServerError,
			Message: "failed",
		}
		expJson, _ := json.Marshal(exp)
		require.Equal(t, exp.Status, w.Code)
		require.Equal(t, expJson, w.Body.Bytes())
	})
}
