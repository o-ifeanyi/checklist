package service

import (
	"checklist/checklist_api/mock"
	"checklist/checklist_api/model"
	"errors"
	"testing"

	m "github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"
)

func TestSync(t *testing.T) {
	checklists := []model.Checklist{}

	t.Run("return nil on success", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("AllChecklist", m.Anything).Return(checklists, nil)

		cs := ChecklistService{ms}

		_, err := cs.Sync("userid", checklists)
		require.ErrorIs(t, err, nil)
	})

	t.Run("return err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("AllChecklist", m.Anything).Return(checklists, errors.New("failed"))

		cs := ChecklistService{ms}

		_, err := cs.Sync("userid", checklists)
		require.NotEmpty(t, err)
	})
}

func TestGetAll(t *testing.T) {
	checklists := []model.Checklist{}

	t.Run("return nil on success", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("AllChecklist", m.Anything).Return(checklists, nil)

		cs := ChecklistService{ms}

		_, err := cs.GetAll("userid")
		require.ErrorIs(t, err, nil)
	})

	t.Run("return err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("AllChecklist", m.Anything).Return(checklists, errors.New("failed"))

		cs := ChecklistService{ms}

		_, err := cs.GetAll("userid")
		require.NotEmpty(t, err)
	})
}

func TestCreatee(t *testing.T) {
	checklist := model.Checklist{}

	t.Run("return nil on success", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("Insert", "checklist", m.Anything).Return(nil)

		cs := ChecklistService{ms}

		err := cs.Create(checklist)
		require.ErrorIs(t, err, nil)
	})

	t.Run("return err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("Insert", "checklist", m.Anything).Return(errors.New("failed"))

		cs := ChecklistService{ms}

		err := cs.Create(checklist)
		require.NotEmpty(t, err)
	})
}

func TestUpdate(t *testing.T) {
	checklist := model.Checklist{}

	t.Run("return nil on success", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("Update", "checklist", m.Anything, m.Anything).Return(nil)

		cs := ChecklistService{ms}

		err := cs.Update(checklist)
		require.ErrorIs(t, err, nil)
	})

	t.Run("return err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("Update", "checklist", m.Anything, m.Anything).Return(errors.New("failed"))

		cs := ChecklistService{ms}

		err := cs.Update(checklist)
		require.NotEmpty(t, err)
	})
}

func TestDelete(t *testing.T) {
	checklist := model.Checklist{}

	t.Run("return nil on success", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("Delete", "checklist", m.Anything).Return(nil)

		cs := ChecklistService{ms}

		err := cs.Delete(checklist.Id)
		require.ErrorIs(t, err, nil)
	})

	t.Run("return err on error", func(t *testing.T) {
		ms := new(mock.MongoService)
		ms.On("Delete", "checklist", m.Anything).Return(errors.New("failed"))

		cs := ChecklistService{ms}

		err := cs.Delete(checklist.Id)
		require.NotEmpty(t, err)
	})
}
