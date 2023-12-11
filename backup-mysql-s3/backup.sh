#!/bin/bash

# Create temporary directory
DIR=$(mktemp -d)
DATE_VALUE=$(date '-R')
DATE_TIME=$(date '+%FT%T')

DATE_YEAR=$(date +%Y)
DATE_MONTH=$(date +%m)
DATE_DAY=$(date +%m)

# Helper to fail with message
_fatal() {
  printf "Fatal: %s\n" "$@" >&2
  exit 1
}

# Cleanup
# Arguments
#   1) Directory to save files to
_cleanup() {
    [ -d "${DIR}" ] && rm -rf "${DIR}"
}

# Bootstrap using a configuration file
_bootstrap() {
    # Get secret values from files
    [ -r "${DB_PASS_FILE}" ] && DB_PASS=$(cat "${DB_PASS_FILE}")

    # Ensure variables are set
    [ -z "${BACKUP_DATABASES}" ] && _fatal "'BACKUP_DATABASES' not set"
    [ -z "${DB_USER}" ] && _fatal "'DB_USER' not set"
    [ -z "${DB_PASS}" ] && _fatal "'DB_PASS' not set"

    # Add endpoint
    AWS="aws"
    [ -n "${S3_ENDPOINT_URL}" ] && AWS="aws --endpoint-url ${S3_ENDPOINT_URL}"
    export AWS

    # Get access key id from file
    if [ -r "${AWS_ACCESS_KEY_ID_FILE}" ]; then
        AWS_ACCESS_KEY_ID=$(head -n1 "${AWS_ACCESS_KEY_ID_FILE}")
        export AWS_ACCESS_KEY_ID
    fi

    # Get secret access key from file
    if [ -r "${AWS_SECRET_ACCESS_KEY_FILE}" ]; then
        AWS_SECRET_ACCESS_KEY=$(head -n1 "${AWS_SECRET_ACCESS_KEY_FILE}")
        export AWS_SECRET_ACCESS_KEY
    fi

    # Ensure required variables are set
    # [ -z "${ALPHA}" ] && _fatal "'ALPHA' location not set in first entrypoint argument"
    # [ -z "${BETA}" ] && _fatal "'BETA' location not set in second entrypoint argument"
}

# Export database data
# Arguments
#   1) Directory to save files to
_export_db() {
    local WORKDIR="${1}"
    [ -n "${WORKDIR}" ] || _fatal "No directory specified for exports."

    local -a DATABASES
    IFS=',' read -ra DATABASES <<< "${BACKUP_DATABASES}"

    local SSL_FLAG=""
    [ -n "${DB_SSL}" ] && SSL_FLAG="--ssl"

    for DB in "${DATABASES[@]}"; do
        mysqldump \
            ${SSL_FLAG} \
            --user="${DB_USER}" \
            --password="${DB_PASS}" \
            --host="${DB_HOST:-localhost}" \
            --port="${DB_PORT:-3306}" \
            "${DB}" > "${WORKDIR}/${DB}.sql" || _fatal "Could not backup database '${DB}'"
    done
}

# Run the backup job
# Arguments
#   1) Directory to read files from
function _backup() {
    local WORKDIR="${1}"
    [ -n "${WORKDIR}" ] || _fatal "No directory specified for uploads."

    local -a FILES
    FILES=$(ls ${WORKDIR}/*.sql)

    # Only continue if files have been written
    if [ "${#FILES[@]}" -gt 0 ]; then
        # Compress backup
        FILE_NAME="db-backups_${DATE_TIME}.tar.gz"
        FILE="/tmp/${FILE_NAME}"
        tar -zcf "${FILE}" -C "${WORKDIR}" . || _fatal "An error occurred while compressing the backup files."
        mv "${FILE}" "${WORKDIR}/${FILE_NAME}"
        FILE="${WORKDIR}/${FILE_NAME}"

        if [ -n "${S3_LATEST_FILE_PATH}" ]; then
            $AWS s3 cp "${FILE}" "${S3_LATEST_FILE_PATH}"
        fi

        # Build upload file location
        UPLOAD_LOCATION="${S3_BUCKET_PATH}/${FILE_NAME}"
        UPLOAD_LOCATION=$(echo $UPLOAD_LOCATION | sed "s/{year}/$DATE_YEAR/g")
        UPLOAD_LOCATION=$(echo $UPLOAD_LOCATION | sed "s/{month}/$DATE_MONTH/g")
        UPLOAD_LOCATION=$(echo $UPLOAD_LOCATION | sed "s/{day}/$DATE_DAY/g")

        $AWS s3 cp "${FILE}" "${UPLOAD_LOCATION}" \
            && return 0 \
            || return 1
    fi
}

trap _cleanup EXIT
_bootstrap
_export_db "${DIR}"
_backup "${DIR}"
_cleanup
