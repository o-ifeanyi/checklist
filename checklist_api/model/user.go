package model

type User struct {
	Id       string `json:"id"`
	Email    string `json:"email"`
	Password []byte `json:"password"`
	Session  string `json:"session"`
}
