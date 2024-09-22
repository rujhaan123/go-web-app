# Containerize the Go application that we have created
# This is the Dockerfile that we will use to build the image
# and run the container

# Start with a base image
FROM --platform=linux/arm64 golang:1.22 AS base

# Set the working directory inside the container
WORKDIR /app

# Set the target architecture and disable CGO
ENV GOARCH=arm64
ENV CGO_ENABLED=0

# Copy the go.mod and go.sum files to the working directory
COPY go.mod ./

# Download all the dependencies
RUN go mod download

# Copy the source code to the working directory
COPY . .

# Build the application
RUN go build -o main .

# List the contents of the /app directory
RUN ls -l /app

#######################################################
# Reduce the image size using multi-stage builds
# We will use an Alpine image to run the application
FROM --platform=linux/arm64 arm64v8/alpine:latest

# Install necessary packages (if any)
RUN apk add --no-cache ca-certificates

# Copy the binary from the previous stage
COPY --from=base /app/main .

# Copy the static files from the previous stage
COPY --from=base /app/static ./static

# List the contents of the root directory
RUN ls -l /

# Expose the port on which the application will run
EXPOSE 8080

# Command to run the application
CMD ["./main"]
