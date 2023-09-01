#########
# BUILD #
#########
ARG GO_VERSION="1.21.0"
ARG ALPINE_VERSION="3.17.5"
FROM golang:${GO_VERSION}-alpine as build

LABEL org.opencontainers.image.source=https://github.com/lstellway/containers
LABEL org.opencontainers.image.description="Simple HTTP server written in Go to get client IP info"
LABEL org.opencontainers.image.licenses=MIT

ENV API_PORT=8080
WORKDIR /go/src/app
COPY ./src/* .
RUN CGO_ENABLED=0 GOOS=linux go build -o app main.go

#######
# RUN #
#######
FROM alpine:${ALPINE_VERSION}

COPY --from=build /go/src/app/app /app
RUN adduser -u 1000 -H -D app \
    && chown 1000:1000 /app

ENTRYPOINT ["./app"]
