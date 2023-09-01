#########
# BUILD #
#########
ARG GO_VERSION="1.21.0"
ARG ALPINE_VERSION="3.17.5"
FROM golang:${GO_VERSION}-alpine as build

LABEL org.opencontainers.image.source=https://github.com/lstellway/containers
LABEL org.opencontainers.image.description="Script written in Go to set DNS records for host in CloudFlare"
LABEL org.opencontainers.image.licenses=MIT

WORKDIR /go
COPY ./src /go/appsrc
RUN apk add --no-cache git \
    && go get github.com/cloudflare/cloudflare-go \
    && go build -o app ./appsrc/*

#######
# RUN #
#######
FROM alpine:${ALPINE_VERSION}

COPY --from=build /go/app /app

RUN mkdir -p /etc/crontabs/ \
    && echo "*/15   *   *   *   *   /app" > /etc/crontabs/root

ENTRYPOINT [ "crond", "-f" ]
