FROM golang:1.25-alpine AS builder

RUN apk add --no-cache gcc musl-dev libc6-compat sqlite-dev

WORKDIR /app

COPY backend/go.mod backend/go.sum ./
RUN go env -w GONOSUMCHECK=* && go mod download

COPY backend/ ./

RUN CGO_ENABLED=0 go build -ldflags='-s -w -extldflags "-static"' -o merope-api ./cmd/api/main.go

FROM scratch

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app/merope-api /merope-api

EXPOSE 8080
ENTRYPOINT ["/merope-api"]
