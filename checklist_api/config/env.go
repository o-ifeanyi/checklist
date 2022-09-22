package config

import (
	"log"

	"github.com/joho/godotenv"
)

func LoadEnvFile(env string) {
	if env == "prod" {
		err := godotenv.Load("prod.env")
		if err != nil {
			log.Fatal("Error loading .env file")
		}
	} else {
		err := godotenv.Load("dev.env")
		if err != nil {
			log.Fatal("Error loading .env file")
		}
	}
}
