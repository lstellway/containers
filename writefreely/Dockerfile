# Build image
FROM golang:1.19-alpine as build
ARG WRITEFREELY_REPO="https://github.com/writefreely/writefreely.git"

WORKDIR /go/src/github.com/writefreely/writefreely

ENV \
    GO111MODULE=on \
    NODE_OPTIONS=--openssl-legacy-provider \
    WRITEFREELY_REPO="${WRITEFREELY_REPO}"

RUN \
    apk add --update nodejs npm make g++ git

RUN \
    && git clone "${WRITEFREELY_REPO}" . \
    && npm install -g less less-plugin-clean-css \
    && cat ossl_legacy.cnf > /etc/ssl/openssl.cnf \
    && make build \
    && make ui

RUN \
    mkdir /stage && \
    cp -R /go/bin \
        /go/src/github.com/writefreely/writefreely/templates \
        /go/src/github.com/writefreely/writefreely/static \
        /go/src/github.com/writefreely/writefreely/pages \
        /go/src/github.com/writefreely/writefreely/keys \
        /go/src/github.com/writefreely/writefreely/cmd \
        /stage

# Final image
FROM alpine:3.17.5

RUN apk add --no-cache openssl ca-certificates
COPY --from=build --chown=daemon:daemon /stage /go

WORKDIR /go
VOLUME /go/keys
EXPOSE 8080
USER daemon

ENTRYPOINT ["cmd/writefreely/writefreely"]
