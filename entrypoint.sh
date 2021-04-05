#!/bin/sh
set -e

function require_env() {
    if [ "$#" -ne 1 ] || [ -z "$1" ]; then
        echo "require_env requires 1 argument" >&2
        exit 1
    fi
    NAME="$1"
    VALUE=$(printenv "${NAME}") || true
    if [ -z "${VALUE}" ]; then
        echo "ERROR: Environment variable ${NAME} is required but not set" >&2
        exit 1
    fi
}

require_env CERTBOT_DOMAIN
CERTBOT_SCHEDULE="${CERTBOT_SCHEDULE:-0 0 * * *}"

mkdir -p /webroot

/httpd &

/certonly.sh

/go-cron "${CERTBOT_SCHEDULE}" /certonly.sh
