# Go Web Application

This is a simple website written in Golang. It uses the `net/http` package to serve HTTP requests.

## Running the server

To run the server, execute the following command:

```bash
go run main.go
```

The server will start on port 8080. You can access it by navigating to `http://localhost:8080/courses` in your web browser.

## Looks like this

![Website](static/images/golang-website.png)

## Devopsify
We are using Github action for the CI part and gitops using Argo CD for CD.
In CI below stages we will use, 
- Stage 1 will be of Build and Unit Test
- Stage 2 will have static code analysis
- Stage 3 will be of docker image creation and pushing the image
- Stage 4 will be of update helm, for the particular commit developer has made the docker image created will be mapped with it so it can have a new tag and that new tag will be updated in values.yaml

IN CD part, whenever the values.yaml is updated argocd will pull helm chart and install it on the cluster


