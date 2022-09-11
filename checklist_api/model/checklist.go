package model

type Checklist struct {
	Id        string          `json:"id,omitempty"`
	UserId    string          `json:"userId,omitempty"`
	Title     string          `json:"title,omitempty"`
	UpdatedAt int             `json:"updatedAt,omitempty"`
	Action    string          `json:"action,omitempty"`
	Items     []ChecklistItem `json:"items,omitempty"`
}

type ChecklistItem struct {
	Text string `json:"text,omitempty"`
	Done bool   `json:"done,omitempty"`
}
