package model

type User struct {
	Id       string `json:"id,omitempty"`
	Email    string `json:"email,omitempty"`
	Password []byte `json:"password,omitempty"`
	Session  string `json:"session,omitempty"`
}
