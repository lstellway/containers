ARG ALPINE_VERSION=3.17.5
FROM alpine:${ALPINE_VERSION}

LABEL org.opencontainers.image.source=https://github.com/lstellway/containers
LABEL org.opencontainers.image.description="A container intended to backup MySQL databases and store backups in an S3 compatible service"
LABEL org.opencontainers.image.licenses=MIT

# Environment variables
# This script utilizes the AWS command-line interface program
# As a result, this program supports related environment variables:
# @see https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
ENV BACKUP_DATABASES= \
    DB_USER= \
    DB_PASS= \
    DB_HOST=localhost \
    DB_PORT=3306 \
    AWS_ACCESS_KEY_ID_FILE= \
    AWS_SECRET_ACCESS_KEY_FILE= \
    S3_ENDPOINT_URL= \
    S3_BUCKET_PATH=

COPY backup.sh /etc/periodic/daily/backup

RUN apk --update add --no-cache \
    bash mysql-client aws-cli \
    && chmod +x /etc/periodic/daily/backup

CMD [ "crond", "-f" ]
