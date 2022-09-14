package mock

import (
	"checklist/checklist_api/model"

	"github.com/stretchr/testify/mock"
)

type ChecklistService struct {
	mock.Mock
}

func (c ChecklistService) Sync(userId string, checklists []model.Checklist) ([]model.Checklist, error) {
	args := c.Called(checklists)
	return checklists, args.Error(1)
}
func (c ChecklistService) GetAll(userId string) ([]model.Checklist, error) {
	args := c.Called(userId)
	return []model.Checklist{}, args.Error(1)
}
func (c ChecklistService) Create(checklist model.Checklist) error {
	args := c.Called(checklist)
	return args.Error(0)
}
func (c ChecklistService) Update(checklist model.Checklist) error {
	args := c.Called(checklist)
	return args.Error(0)
}
func (c ChecklistService) Delete(checklistId string) error {
	args := c.Called(checklistId)
	return args.Error(0)
}
