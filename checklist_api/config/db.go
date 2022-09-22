package config

import (
	"context"
	"flag"
	"log"
	"os"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"go.mongodb.org/mongo-driver/mongo/readpref"
)

var DB *mongo.Database

var Ctx context.Context

var env string

func init() {
	flag.StringVar(&env, "env", "local", "The application env variable")
	flag.Parse()

	LoadEnvFile(env)

	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
	defer cancel()
	uri := os.Getenv("MONGO_URI")

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

// create: curl -v -H "Authorization: <token>" -d '{"id":"ifeanyi@gmail.com","title":"test checklist", "action":"create", "items":[{"text":"first task", "done":true}]}' http://localhost:8080/user/create
// update: curl -v -H "Authorization: <token>" -d '{"id":"ifeanyi@gmail.com","title":"test checklist updated", "action":"create", "items":[{"text":"first task", "done":true}]}' http://localhost:8080/user/update
// delete: curl -v -X DELETE -H "Authorization: <token>" http://localhost:8080/user/delete/ifeanyi@gmail.com

//eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMmE1NDA1OTEtN2VhZi00ODk3LWI2YzctNjQ1ODVjMDNkNjYyIn0._YWwMiHqg-AflJ3Byesu_IEeM5pISIRUH4tsbdiY4LA
