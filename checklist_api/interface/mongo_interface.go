package inter

import (
	"checklist/checklist_api/model"
)

type MongoInterface interface {
	FindUser(filter interface{}) (model.User, error)
	AllChecklist(filter interface{}) ([]model.Checklist, error)
	Insert(col string, doc interface{}) error
	Update(col string, filter interface{}, doc interface{}) error
	Delete(col string, filter interface{}) error
}
