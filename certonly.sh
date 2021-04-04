#!/bin/sh
CERTBOT_EMAIL=${CERTBOT_EMAIL:-postmaster@$CERTBOT_DOMAIN}
CERTBOT_PREHOOK=${CERTBOT_PREHOOK:-/bin/true}
CERTBOT_POSTHOOK=${CERTBOT_POSTHOOK:-/bin/true}

certbot certonly --non-interactive --webroot --webroot-path=/webroot \
        -d ${CERTBOT_DOMAIN} --agree-tos --email ${CERTBOT_EMAIL} \
        --rsa-key-size 4096 --keep-until-expiring --preferred-challenges=http \
        --pre-hook "${CERTBOT_PREHOOK}" --post-hook "${CERTBOT_POSTHOOK}" \
	${CERTBOT_EXTRA_ARGS}
