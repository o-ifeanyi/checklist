package service

import (
	"checklist/checklist_api/mock"
	"checklist/checklist_api/model"
	"errors"
	"testing"

	m "github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"
)

func TestFindById(t *testing.T) {
	user := model.User{}

	t.Run("return nil on success", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, nil)

		as := AuthService{ms}

		_, err := as.FindById(user.Id)
		require.ErrorIs(t, err, nil)
	})

	t.Run("return err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, errors.New("failed"))

		as := AuthService{ms}

		_, err := as.FindById(user.Id)
		require.NotEmpty(t, err)
	})
}

func TestFindByEmail(t *testing.T) {
	user := model.User{}

	t.Run("return nil on success", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, nil)

		as := AuthService{ms}

		_, err := as.FindByEmail(user.Email)
		require.ErrorIs(t, err, nil)
	})

	t.Run("return err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, errors.New("failed"))

		as := AuthService{ms}

		_, err := as.FindByEmail(user.Email)
		require.NotEmpty(t, err)
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
		require.NotEmpty(t, token)
		require.ErrorIs(t, err, nil)
	})

	t.Run("return empty token and err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, errors.New("failed"))
		ms.On("Insert", "users", m.Anything).Return(errors.New("failed"))

		as := AuthService{ms}

		token, err := as.Create("email", "123456")
		require.Empty(t, token)
		require.NotEmpty(t, err)
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
		require.NotEmpty(t, token)
		require.ErrorIs(t, err, nil)
	})

	t.Run("return empty token and err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, errors.New("failed"))
		ms.On("Update", "users", m.Anything, m.Anything).Return(errors.New("failed"))

		as := AuthService{ms}

		token, err := as.Login("email", "123456")
		require.Empty(t, token)
		require.NotEmpty(t, err)
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
		require.ErrorIs(t, err, nil)
	})

	t.Run("return err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, errors.New("failed"))
		ms.On("Update", "users", m.Anything, m.Anything).Return(errors.New("failed"))

		as := AuthService{ms}

		err := as.Logout("id")
		require.NotEmpty(t, err)
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
		require.ErrorIs(t, err, nil)
	})

	t.Run("return err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("FindUser", m.Anything).Return(user, errors.New("failed"))
		ms.On("Delete", "users", m.Anything, m.Anything).Return(errors.New("failed"))
		ms.On("DeleteAll", "checklist", m.Anything, m.Anything).Return(errors.New("failed"))

		as := AuthService{ms}

		err := as.Delete("id")
		require.NotEmpty(t, err)
	})
}
