FROM golang:1.25-alpine AS builder

RUN apk add --no-cache ca-certificates
WORKDIR /app

COPY backend/go.mod backend/go.sum ./
RUN go mod download

COPY backend/ ./
RUN CGO_ENABLED=0 go build -trimpath -ldflags='-s -w' -o /merope-api ./cmd/api

FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /merope-api /merope-api

EXPOSE 8080
USER nonroot:nonroot
ENTRYPOINT ["/merope-api"]
