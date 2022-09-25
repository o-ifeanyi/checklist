# Checklist Api

This is a project built to practice what I've earnt with Go. This API is consumed by [checklist_app](https://github.com/o-ifeanyi/checklist/tree/master/checklist_app)

### Environment setup
This is a Flutter application and requires you to have Go or Docker and mongodb installed on your computer. 

### Go installation
You should follow the [Flutter installation guide here](https://flutter.dev/docs/get-started/install)

### Setting up locally 
- Clone the repo locally
- Navigate to the folder and run `go get -d` to install the required dependencies

### Running the application
Simply run `go run main.go` command from the terminal

### Docker installation
You should follow the [Flutter installation guide here](https://flutter.dev/docs/get-started/install)

### Setting up locally
- Pull image from [repo on docker hub](https://hub.docker.com/repository/docker/oifeanyi/checklist_api)

### Running the application
Run container using docker desktop or with the following command `docker run --name <container_name> -p 8080:8080 -d <image_name>`

### Running the test
Simply run `go test ./...`
