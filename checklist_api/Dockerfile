FROM golang:1.19

WORKDIR /checklist_api

COPY . .

RUN go get -d
RUN go build

EXPOSE 8080

CMD ["./checklist_api", "-env=prod"]