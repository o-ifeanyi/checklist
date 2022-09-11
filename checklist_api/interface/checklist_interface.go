package inter

import (
	"checklist/checklist_api/model"
)

type ChecklistInterface interface {
	Sync(checklists []model.Checklist) ([]model.Checklist, error)
	GetAll(userId string) ([]model.Checklist, error)
	Create(checklist model.Checklist) error
	Update(checklist model.Checklist) error
	Delete(checklistId string) error
}
