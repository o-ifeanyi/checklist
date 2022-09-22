package service

import (
	"checklist/checklist_api/model"
	"context"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

type MongoService struct {
	DB *mongo.Database
}

func NewMongoService(DB *mongo.Database) MongoService {
	return MongoService{DB: DB}
}

func (ms MongoService) FindUser(filter interface{}) (model.User, error) {
	user := model.User{}
	res := ms.DB.Collection("users").FindOne(context.Background(), filter)

	err := res.Decode(&user)
	if err != nil {
		return user, err
	}
	return user, nil
}

func (ms MongoService) AllChecklist(filter interface{}) ([]model.Checklist, error) {
	items := []model.Checklist{}
	cur, err := ms.DB.Collection("checklist").Find(context.Background(), filter)
	if err != nil {
		return items, err
	}
	cur.All(context.Background(), &items)
	return items, nil
}

func (ms MongoService) Insert(col string, doc interface{}) error {
	_, insertErr := ms.DB.Collection(col).InsertOne(context.Background(), doc)
	if insertErr != nil {
		return insertErr
	}
	return nil
}

func (ms MongoService) Update(col string, filter interface{}, doc interface{}) error {
	_, updateErr := ms.DB.Collection(col).UpdateOne(context.Background(), filter, bson.M{"$set": &doc})
	if updateErr != nil {
		return updateErr
	}

	return nil
}

func (ms MongoService) Delete(col string, filter interface{}) error {
	_, deleteErr := ms.DB.Collection(col).DeleteOne(context.Background(), filter)
	if deleteErr != nil {
		return deleteErr
	}

	return nil
}

func (ms MongoService) DeleteAll(col string, filter interface{}) error {
	_, deleteErr := ms.DB.Collection(col).DeleteMany(context.Background(), filter)
	if deleteErr != nil {
		return deleteErr
	}

	return nil
}
