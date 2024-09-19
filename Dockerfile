# Containerize the go application that we have created
# Start with a base image for ARM64
FROM --platform=linux/arm64 golang:1.22 as base

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files to the working directory
COPY go.mod ./

# Download all the dependencies
RUN go mod download

# Copy the source code to the working directory
COPY . .

# Explicitly set architecture and OS for ARM64 and Linux, and disable CGO for a static binary
RUN CGO_ENABLED=0 GOARCH=arm64 GOOS=linux go build -o main .

#######################################################
# Reduce the image size using multi-stage builds
# Use a distroless image to run the application
FROM gcr.io/distroless/base

# Copy the binary from the previous stage
COPY --from=base /app/main .

# Copy the static files from the previous stage
COPY --from=base /app/static ./static

# Expose the port on which the application will run
EXPOSE 8080

# Command to run the application
CMD ["./main"]
