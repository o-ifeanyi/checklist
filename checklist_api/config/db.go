package config

import (
	"context"
	"log"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"go.mongodb.org/mongo-driver/mongo/readpref"
)

var DB *mongo.Database

var Ctx context.Context

func init() {
	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
	defer cancel()
	uri := "mongodb://testuser:dbpassword@localhost:27017/checklistdb"

	client, err := mongo.Connect(ctx, options.Client().ApplyURI(uri))
	if err != nil {
		panic(err)
	}

	if err := client.Ping(ctx, readpref.Primary()); err != nil {
		panic(err)
	}
	DB = client.Database("checklistdb")

	log.Println("Successfully connected and pinged.")
}

// register: curl -v -H "Content-Type: application/json" -d '{"email":"ifeanyi@gmail.com","password":"never4get"}' http://localhost:8080/auth/register
// login: curl -v -H "Content-Type: application/json" -d '{"email":"ifeanyi@gmail.com","password":"never4get"}' http://localhost:8080/auth/login
// logout: curl -v -H "Authorization: <token>" http://localhost:8080/logout
