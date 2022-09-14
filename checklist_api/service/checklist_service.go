package service

import (
	inter "checklist/checklist_api/interface"
	"checklist/checklist_api/model"
	"errors"
	"log"

	"go.mongodb.org/mongo-driver/bson"
)

type ChecklistService struct {
	DB inter.MongoInterface
}

func NewChecklistService(DB inter.MongoInterface) ChecklistService {
	return ChecklistService{DB: DB}
}

func (cs ChecklistService) Sync(userId string, checklists []model.Checklist) ([]model.Checklist, error) {
	for _, checklist := range checklists {
		switch checklist.Action {
		case "create":
			cs.Create(checklist)
		case "update":
			cs.Update(checklist)
		case "delete":
			cs.Delete(checklist.Id)
		}
	}

	items, err := cs.GetAll(userId)
	if err != nil {
		log.Println(err)
		return items, err
	}
	return items, nil
}

func (cs ChecklistService) GetAll(userId string) ([]model.Checklist, error) {
	var items []model.Checklist

	items, err := cs.DB.AllChecklist(bson.M{"userId": userId})
	if err != nil {
		log.Println(err)
		return items, errors.New("items not found")
	}

	return items, nil
}

func (cs ChecklistService) Create(checklist model.Checklist) error {
	insertErr := cs.DB.Insert("checklist", checklist)
	if insertErr != nil {
		log.Println(insertErr)
		return errors.New("create checklist failed")
	}

	return nil
}

func (cs ChecklistService) Update(checklist model.Checklist) error {
	updateErr := cs.DB.Update("checklist", bson.M{"id": checklist.Id}, checklist)
	if updateErr != nil {
		log.Println(updateErr)
		return errors.New("update checklist failed")
	}

	return nil
}

func (cs ChecklistService) Delete(checklistId string) error {
	deleteErr := cs.DB.Delete("checklist", bson.M{"id": checklistId})
	if deleteErr != nil {
		log.Println(deleteErr)
		return errors.New("delete checklist failed")
	}

	return nil
}
