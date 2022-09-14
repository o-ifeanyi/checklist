package service

import (
	"checklist/checklist_api/mock"
	"checklist/checklist_api/model"
	"errors"
	"testing"

	"github.com/stretchr/testify/assert"
	m "github.com/stretchr/testify/mock"
)

func TestSync(t *testing.T) {
	checklists := []model.Checklist{}

	t.Run("return nil on success", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("AllChecklist", m.Anything).Return(checklists, nil)

		cs := ChecklistService{ms}

		_, err := cs.Sync("userid", checklists)
		assert.ErrorIs(t, err, nil)
	})

	t.Run("return err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("AllChecklist", m.Anything).Return(checklists, errors.New("failed"))

		cs := ChecklistService{ms}

		_, err := cs.Sync("userid", checklists)
		assert.ErrorContains(t, err, "failed")
	})
}

func TestGetAll(t *testing.T) {
	checklists := []model.Checklist{}

	t.Run("return nil on success", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("AllChecklist", m.Anything).Return(checklists, nil)

		cs := ChecklistService{ms}

		_, err := cs.GetAll("userid")
		assert.ErrorIs(t, err, nil)
	})

	t.Run("return err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("AllChecklist", m.Anything).Return(checklists, errors.New("failed"))

		cs := ChecklistService{ms}

		_, err := cs.GetAll("userid")
		assert.ErrorContains(t, err, "failed")
	})
}

func TestCreatee(t *testing.T) {
	checklist := model.Checklist{}

	t.Run("return nil on success", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("Insert", "checklist", m.Anything).Return(nil)

		cs := ChecklistService{ms}

		err := cs.Create(checklist)
		assert.ErrorIs(t, err, nil)
	})

	t.Run("return err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("Insert", "checklist", m.Anything).Return(errors.New("failed"))

		cs := ChecklistService{ms}

		err := cs.Create(checklist)
		assert.ErrorContains(t, err, "failed")
	})
}

func TestUpdate(t *testing.T) {
	checklist := model.Checklist{}

	t.Run("return nil on success", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("Update", "checklist", m.Anything, m.Anything).Return(nil)

		cs := ChecklistService{ms}

		err := cs.Update(checklist)
		assert.ErrorIs(t, err, nil)
	})

	t.Run("return err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("Update", "checklist", m.Anything, m.Anything).Return(errors.New("failed"))

		cs := ChecklistService{ms}

		err := cs.Update(checklist)
		assert.ErrorContains(t, err, "failed")
	})
}

func TestDelete(t *testing.T) {
	checklist := model.Checklist{}

	t.Run("return nil on success", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("Delete", "checklist", m.Anything).Return(nil)

		cs := ChecklistService{ms}

		err := cs.Delete(checklist.Id)
		assert.ErrorIs(t, err, nil)
	})

	t.Run("return err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("Delete", "checklist", m.Anything).Return(errors.New("failed"))

		cs := ChecklistService{ms}

		err := cs.Delete(checklist.Id)
		assert.ErrorContains(t, err, "failed")
	})
}
