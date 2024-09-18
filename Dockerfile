# Stage 1: Build the Go binary
FROM golang:1.22 as base

WORKDIR /app

COPY go.mod .
RUN go mod download

COPY . .

# Build the binary for arm64 architecture
RUN GOOS=linux GOARCH=arm64 go build -o main .

# Stage 2: Use a minimal base image (Distroless)
FROM gcr.io/distroless/base

# Copy the binary from the previous stage
COPY --from=base /app/main .

# Copy static content if needed (ensure this path exists)
COPY --from=base /app/static ./static

EXPOSE 8080

# Run the binary
CMD ["./main"]
