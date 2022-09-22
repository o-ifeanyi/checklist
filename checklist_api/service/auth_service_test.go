package service

import (
	"checklist/checklist_api/mock"
	"checklist/checklist_api/model"
	"errors"
	"testing"

	"github.com/stretchr/testify/assert"
	m "github.com/stretchr/testify/mock"
)

func TestFindById(t *testing.T) {
	user := model.User{}

	t.Run("return nil on success", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, nil)

		as := AuthService{ms}

		_, err := as.FindById(user.Id)
		assert.ErrorIs(t, err, nil)
	})

	t.Run("return err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, errors.New("failed"))

		as := AuthService{ms}

		_, err := as.FindById(user.Id)
		assert.NotEmpty(t, err)
	})
}

func TestFindByEmail(t *testing.T) {
	user := model.User{}

	t.Run("return nil on success", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, nil)

		as := AuthService{ms}

		_, err := as.FindByEmail(user.Email)
		assert.ErrorIs(t, err, nil)
	})

	t.Run("return err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, errors.New("failed"))

		as := AuthService{ms}

		_, err := as.FindByEmail(user.Email)
		assert.NotEmpty(t, err)
	})
}

func TestCreate(t *testing.T) {
	user := model.User{}

	t.Run("return token on success", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, nil)
		ms.On("Insert", "users", m.Anything).Return(nil)

		as := AuthService{ms}

		token, err := as.Create("email", "123456")
		assert.NotEmpty(t, token)
		assert.ErrorIs(t, err, nil)
	})

	t.Run("return empty token and err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, errors.New("failed"))
		ms.On("Insert", "users", m.Anything).Return(errors.New("failed"))

		as := AuthService{ms}

		token, err := as.Create("email", "123456")
		assert.Empty(t, token)
		assert.NotEmpty(t, err)
	})
}

func TestLogin(t *testing.T) {
	user := model.User{}

	t.Run("return token on success", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, nil)
		ms.On("Update", "users", m.Anything, m.Anything).Return(nil)

		as := AuthService{ms}

		token, err := as.Login("email", "123456")
		assert.NotEmpty(t, token)
		assert.ErrorIs(t, err, nil)
	})

	t.Run("return empty token and err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, errors.New("failed"))
		ms.On("Update", "users", m.Anything, m.Anything).Return(errors.New("failed"))

		as := AuthService{ms}

		token, err := as.Login("email", "123456")
		assert.Empty(t, token)
		assert.NotEmpty(t, err)
	})
}

func TestLogout(t *testing.T) {
	user := model.User{}

	t.Run("return nil on success", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, nil)
		ms.On("Update", "users", m.Anything, m.Anything).Return(nil)

		as := AuthService{ms}

		err := as.Logout("id")
		assert.ErrorIs(t, err, nil)
	})

	t.Run("return err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, errors.New("failed"))
		ms.On("Update", "users", m.Anything, m.Anything).Return(errors.New("failed"))

		as := AuthService{ms}

		err := as.Logout("id")
		assert.NotEmpty(t, err)
	})
}

func TestDeleteUser(t *testing.T) {
	user := model.User{}

	t.Run("return nil on success", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, nil)
		ms.On("Delete", "users", m.Anything, m.Anything).Return(nil)
		ms.On("DeleteAll", "checklist", m.Anything, m.Anything).Return(nil)

		as := AuthService{ms}

		err := as.Delete("id")
		assert.ErrorIs(t, err, nil)
	})

	t.Run("return err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, errors.New("failed"))
		ms.On("Delete", "users", m.Anything, m.Anything).Return(errors.New("failed"))
		ms.On("DeleteAll", "checklist", m.Anything, m.Anything).Return(errors.New("failed"))

		as := AuthService{ms}

		err := as.Delete("id")
		assert.NotEmpty(t, err)
	})
}
