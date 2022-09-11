package service

import (
	"checklist/checklist_api/model"
	"context"
	"errors"
	"log"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

type ChecklistService struct {
	DB *mongo.Database
}

func NewChecklistService(DB *mongo.Database) ChecklistService {
	return ChecklistService{DB: DB}
}

func (cs ChecklistService) Sync(checklists []model.Checklist) ([]model.Checklist, error) {
	items := []model.Checklist{}
	for _, checklist := range items {
		switch checklist.Action {
		case "create":
			cs.Create(checklist)
		case "update":
			cs.Update(checklist)
		case "delete":
			cs.Delete(checklist.Id)
		}
	}

	items, err := cs.GetAll(checklists[0].UserId)
	if err != nil {
		log.Println(err)
		return items, err
	}
	return items, nil
}

func (cs ChecklistService) GetAll(userId string) ([]model.Checklist, error) {
	items := []model.Checklist{}

	cur, err := cs.DB.Collection("checklist").Find(context.Background(), bson.M{"userId": userId})
	if err != nil {
		log.Println(err)
		return items, errors.New("error finding items")
	}
	cur.All(context.Background(), &items)
	return items, nil
}

func (cs ChecklistService) Create(checklist model.Checklist) error {
	_, insertErr := cs.DB.Collection("checklist").InsertOne(context.Background(), checklist)
	if insertErr != nil {
		log.Println(insertErr)
		return insertErr
	}

	return nil
}

func (cs ChecklistService) Update(checklist model.Checklist) error {
	_, updateErr := cs.DB.Collection("checklist").UpdateOne(context.Background(), bson.M{"id": checklist.Id}, bson.M{"$set": &checklist})
	if updateErr != nil {
		log.Println(updateErr)
		return updateErr
	}

	return nil
}

func (cs ChecklistService) Delete(checklistId string) error {
	_, deleteErr := cs.DB.Collection("checklist").DeleteOne(context.Background(), bson.M{"id": checklistId})
	if deleteErr != nil {
		log.Println(deleteErr)
		return deleteErr
	}

	return nil
}
