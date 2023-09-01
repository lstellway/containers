ARG ALPINE_VERSION=3.17.5
FROM alpine:${ALPINE_VERSION}

LABEL org.opencontainers.image.source=https://github.com/lstellway/containers
LABEL org.opencontainers.image.description="Docker container image used to backup data to S3 using AWS cli"
LABEL org.opencontainers.image.licenses=MIT

# Environment variables
# This script utilizes the AWS command-line interface program
# As a result, this program supports related environment variables:
# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
ENV AWS_ACCESS_KEY_ID_FILE= \
    AWS_SECRET_ACCESS_KEY_FILE= \
    FORCE_INITIAL_RESTORE="false" \
    BACKUP_INTERVAL=42 \
    S3_ENDPOINT_URL= \
    S3_SYNC_RESTORE_FLAGS= \
    S3_SYNC_BACKUP_FLAGS=

COPY entrypoint.sh /entrypoint.sh
RUN apk add --update --no-cache aws-cli \
    && chmod +x /entrypoint.sh

VOLUME /data
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/data" ]

# 5s * 180 retries = 15 minutes
# HEALTHCHECK --interval=5s --retries=180 CMD [ "stat", "/tmp/running" ]
