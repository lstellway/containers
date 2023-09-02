ARG ALPINE_VERSION=3.17.5
FROM alpine:${ALPINE_VERSION}

COPY entrypoint.sh /

LABEL org.opencontainers.image.source=https://github.com/lstellway/containers
LABEL org.opencontainers.image.description="Reassign DigitalOcean Floating IP to Current Droplet"
LABEL org.opencontainers.image.licenses=MIT

RUN apk add --update --no-cache \
    curl bash jq \
    && chmod +x /entrypoint.sh

ENV DO_METADATA_API=http://169.254.169.254\
    DO_API=https://api.digitalocean.com\
    DO_TOKEN=\
    DO_TOKEN_FILE=\
    DO_FLOATING_IP=\
    UPDATE_FREQUENCY=600

ENTRYPOINT [ "/bin/bash", "-c", "/entrypoint.sh" ]
