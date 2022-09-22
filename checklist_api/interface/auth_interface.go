package inter

import (
	"checklist/checklist_api/model"
)

type AuthInterface interface {
	FindById(userID string) (model.User, error)
	FindByEmail(email string) (model.User, error)
	Create(email, password string) (string, error)
	Login(email, password string) (string, error)
	Logout(userId string) error
	Delete(userId string) error
}
