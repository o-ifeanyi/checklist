package model

type Checklist struct {
	Id        string          `json:"id"`
	UserId    string          `json:"userid"`
	Title     string          `json:"title"`
	UpdatedAt int             `json:"updated_at"`
	Action    string          `json:"action"`
	Items     []ChecklistItem `json:"items"`
}

type ChecklistItem struct {
	Id   string `json:"id"`
	Text string `json:"text"`
	Done bool   `json:"done"`
}
