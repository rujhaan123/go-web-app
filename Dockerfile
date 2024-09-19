# Stage 1: Build the Go binary
FROM golang:1.22 AS builder

WORKDIR /app

COPY go.mod .
RUN go mod download

COPY . .

# Build the binary for ARM64
RUN GOARCH=arm64 GOOS=linux go build -o main .

# Stage 2: Use Ubuntu for debugging
FROM ubuntu:22.04

# Install necessary tools for debugging
RUN apt-get update && apt-get install -y file

# Copy the binary from the builder stage
COPY --from=builder /app/main .

# Copy the static files from the previous stage
COPY --from=builder /app/static ./static

# Expose the port on which the application will run
EXPOSE 8080

# Command to run the application
CMD ["./main"]