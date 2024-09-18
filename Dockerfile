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
COPY --from=builder /app/main /app/main

# Set the working directory
WORKDIR /app

# Run the binary to check for execution
CMD ["./main"]
