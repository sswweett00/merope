FROM golang:1.25-alpine AS builder

RUN apk add --no-cache gcc musl-dev sqlite-dev build-base

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 go build -ldflags='-s -w -extldflags "-static"' -o merope-api ./cmd/api/main.go

FROM alpine:3.21
RUN apk add --no-cache ca-certificates tzdata

COPY --from=builder /app/merope-api /usr/local/bin/merope-api

EXPOSE 8080
ENTRYPOINT ["merope-api"]
