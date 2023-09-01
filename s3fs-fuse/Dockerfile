# Builder
ARG ALPINE_VERSION=3.17.5
FROM alpine:${ALPINE_VERSION} as builder
ARG S3FS_VERSION=1.93

LABEL org.opencontainers.image.source=https://github.com/lstellway/containers
LABEL org.opencontainers.image.description="A container intended to mount an S3 bucket via FUSE"
LABEL org.opencontainers.image.licenses=MIT

# Install dependencies
RUN \
    apk add --update --no-cache \
    build-base automake autoconf libxml2-dev fuse-dev curl-dev

# Download source
RUN wget "https://github.com/s3fs-fuse/s3fs-fuse/archive/refs/tags/v${S3FS_VERSION}.tar.gz" -O - | tar -zx

# Build
RUN cd $(ls -d s3fs*) \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && stat /usr/local/bin/s3fs

# Create fresh copy
FROM alpine:${ALPINE_VERSION} as final

RUN apk update \
    && apk add --no-cache libxml2 fuse libcurl libstdc++

COPY --from=builder /usr/local/bin/s3fs /usr/local/bin/s3fs
ENTRYPOINT ["/usr/local/bin/s3fs"]
