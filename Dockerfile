FROM golang:1.22 as base

WORKDIR /app

COPY go.mod .

RUN go mod download

COPY . .

# Build the binary for the correct architecture
RUN GOOS=linux GOARCH=arm64 go build -o main .

RUN go build -o main .

#FInal stage - Distroless image -minimalistic Docker images that contain only the essential components needed to run your application. Unlike traditional container images, which include a full operating system (like Debian or Ubuntu)
FROM gcr.io/distroless/base

#In copy step we are going to copy binary created in previous base image named main which is in /app directory into any directory that we want to setup
COPY --from=base /app/main . 

#reason for this step is static content is not bundled in the binary created and we need in our app
COPY --from=base /app/static ./static

EXPOSE 8080

CMD ["./main"]