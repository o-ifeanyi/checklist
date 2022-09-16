package service

import (
	inter "checklist/checklist_api/interface"
	"checklist/checklist_api/model"
	"checklist/checklist_api/util"
	"errors"
	"log"

	"github.com/google/uuid"
	"go.mongodb.org/mongo-driver/bson"
	"golang.org/x/crypto/bcrypt"
)

type AuthService struct {
	DB inter.MongoInterface
}

func NewAuthService(DB inter.MongoInterface) AuthService {
	return AuthService{DB: DB}
}

func (as AuthService) FindById(userID string) (model.User, error) {

	user, err := as.DB.FindUser(bson.M{"id": userID})
	if err != nil {
		log.Println(err)
		return user, errors.New("user not found")
	}

	return user, nil
}

func (as AuthService) FindByEmail(email string) (model.User, error) {

	user, err := as.DB.FindUser(bson.M{"email": email})
	if err != nil {
		log.Println(err)
		return user, errors.New("user not found")
	}

	return user, nil
}

func (as AuthService) Create(email, password string) (string, error) {

	user, err := as.FindByEmail(email)

	if err == nil && user.Email != "" {
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

	insertErr := as.DB.Insert("users", user)
	if insertErr != nil {
		log.Println(insertErr)
		return "", errors.New("insert user failed")
	}

	return token, nil
}

func (as AuthService) Login(email, password string) (string, error) {

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
	updateErr := as.DB.Update("users", bson.M{"email": user.Email}, user)
	if updateErr != nil {
		log.Println(updateErr)
		return "", errors.New("update user failed")
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
	updateErr := as.DB.Update("users", bson.M{"id": user.Id}, user)
	if updateErr != nil {
		log.Println(updateErr)
		return errors.New("update user failed")
	}
	return nil
}
