package mock

import (
	"checklist/checklist_api/model"

	"github.com/stretchr/testify/mock"
)

type AuthService struct {
	mock.Mock
}

func (w AuthService) FindById(userID string) (model.User, error) {
	args := w.Called(userID)
	return model.User{}, args.Error(1)
}
func (w AuthService) FindByEmail(email string) (model.User, error) {
	args := w.Called(email)
	return model.User{}, args.Error(1)
}
func (w AuthService) Create(email, password string) (string, error) {
	args := w.Called(email, password)
	return args.String(0), args.Error(1)
}
func (w AuthService) Login(email, password string) (string, error) {
	args := w.Called(email, password)
	return args.String(0), args.Error(1)
}
func (w AuthService) Logout(userId string) error {
	args := w.Called(userId)
	return args.Error(0)
}
func (w AuthService) Delete(userId string) error {
	args := w.Called(userId)
	return args.Error(0)
}
