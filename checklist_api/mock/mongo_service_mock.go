package mock

import (
	"checklist/checklist_api/model"

	"github.com/stretchr/testify/mock"
	"golang.org/x/crypto/bcrypt"
)

type MongoService struct {
	mock.Mock
}

func (m MongoService) FindUser(filter interface{}) (model.User, error) {
	args := m.Called(filter)
	bs, _ := bcrypt.GenerateFromPassword([]byte("123456"), bcrypt.MinCost)
	user := model.User{Password: bs}
	return user, args.Error(1)
}
func (m MongoService) AllChecklist(filter interface{}) ([]model.Checklist, error) {
	args := m.Called(filter)
	return []model.Checklist{}, args.Error(1)
}
func (m MongoService) Insert(col string, doc interface{}) error {
	args := m.Called(col, doc)
	return args.Error(0)
}
func (m MongoService) Update(col string, filter interface{}, doc interface{}) error {
	args := m.Called(col, filter, doc)
	return args.Error(0)
}
func (m MongoService) Delete(col string, filter interface{}) error {
	args := m.Called(col, filter)
	return args.Error(0)
}
func (m MongoService) DeleteAll(col string, filter interface{}) error {
	args := m.Called(col, filter)
	return args.Error(0)
}
