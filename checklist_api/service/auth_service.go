package service

import (
	"checklist/checklist_api/model"
	"checklist/checklist_api/util"
	"context"
	"errors"
	"log"

	"github.com/google/uuid"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"golang.org/x/crypto/bcrypt"
)

type AuthService struct {
	DB *mongo.Database
}

func NewAuthService(DB *mongo.Database) AuthService {
	return AuthService{DB: DB}
}

func (as AuthService) FindById(userID string) (model.User, error) {
	user := model.User{}

	res := as.DB.Collection("users").FindOne(context.Background(), bson.M{"id": userID})

	err := res.Decode(&user)
	if err != nil {
		return user, err
	}

	return user, nil
}

func (as AuthService) FindByEmail(email string) (model.User, error) {
	user := model.User{}
	res := as.DB.Collection("users").FindOne(context.Background(), bson.M{"email": email})

	err := res.Decode(&user)
	if err != nil {
		return user, err
	}

	return user, nil
}

func (as AuthService) Create(email, password string) (string, error) {
	user := model.User{}

	if user, err := as.FindByEmail(email); err == nil && user.Email != "" {
		log.Println(err)
		return "", errors.New("user already exist")
	}

	bs, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.MinCost)
	if err != nil {
		log.Println(err)
		return "", err
	}

	user.Id = uuid.NewString()
	token, tokenErr := util.GenerateToken(user.Id)
	if tokenErr != nil {
		log.Println(tokenErr)
		return "", errors.New("generate user token failed")
	}

	user.Email = email
	user.Password = bs
	user.Session = util.GetIdentifier(token)

	_, insertErr := as.DB.Collection("users").InsertOne(context.Background(), user)
	if insertErr != nil {
		log.Println(insertErr)
		return "", insertErr
	}

	return token, nil
}

func (as AuthService) Login(email, password string) (string, error) {
	user := model.User{}

	user, err := as.FindByEmail(email)
	if err != nil {
		log.Println(err)
		return "", errors.New("wrong email or password")
	}

	err = bcrypt.CompareHashAndPassword(user.Password, []byte(password))
	if err != nil {
		log.Println(err)
		return "", errors.New("wrong password or email")
	}

	token, tokenErr := util.GenerateToken(user.Id)
	if tokenErr != nil {
		log.Println(tokenErr)
		return "", errors.New("generate user token failed")
	}

	user.Session = util.GetIdentifier(token)
	_, updateErr := as.DB.Collection("users").UpdateOne(context.Background(), bson.M{"email": user.Email}, bson.M{"$set": &user})
	if updateErr != nil {
		log.Println(updateErr)
		return "", updateErr
	}

	return token, nil
}

func (as AuthService) Logout(userId string) error {
	user, err := as.FindById(userId)
	if err != nil {
		log.Println(err)
		return errors.New("user not found")

	}
	user.Session = ""
	_, updateErr := as.DB.Collection("users").UpdateOne(context.Background(), bson.M{"id": user.Id}, bson.M{"$set": &user})
	if updateErr != nil {
		log.Println(updateErr)
		return updateErr
	}
	return nil
}
