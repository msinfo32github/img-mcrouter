FROM docker.io/golang:1.24.1-alpine3.21 as builder

RUN apk add git && git clone https://github.com/itzg/mc-router

WORKDIR /go/mc-router

RUN go mod download && CGO_ENABLED=0 go build -buildvcs=false ./cmd/mc-router

FROM alpine:3.21
COPY --from=builder /go/mc-router/mc-router /mc-router
RUN adduser --home /nonexistent --no-create-home --disabled-password mc-router
USER mc-router
EXPOSE 25565
CMD ["/mc-router", "--api-binding", "0.0.0.0:8080"]
