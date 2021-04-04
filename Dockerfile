ARG BASE_IMAGE=alpine:3.13.4

FROM ${BASE_IMAGE}
RUN apk add go
ADD httpd /httpd
WORKDIR /httpd
RUN go build

FROM ${BASE_IMAGE}
ARG GOCRON_VERSION=0.0.5
COPY --from=0 /httpd/httpd /httpd
RUN apk add curl certbot dumb-init strace
RUN curl -L https://github.com/ivoronin/go-cron/releases/download/v${GOCRON_VERSION}/go-cron_${GOCRON_VERSION}_linux_amd64.tar.gz | tar xzf - go-cron
ADD entrypoint.sh /entrypoint.sh
ADD certonly.sh /certonly.sh
RUN chmod 755 /entrypoint.sh /certonly.sh
EXPOSE 80/tcp
VOLUME ["/etc/letsencrypt"]
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD /entrypoint.sh
