FROM docker.io/golang:alpine AS go-downloader

RUN go install gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/webtunnel/main/server@latest


FROM docker.io/alpine:latest

LABEL org.opencontainers.image.source https://github.com/FH3095/docker-tor-webtunnel

RUN <<EOF
  set -eu

  apk update
  apk upgrade
  apk --no-cache add \
    bash \
    ca-certificates \
    curl \
    nyx \
    tini \
    tor

  rm -f /etc/tor/torrc
  rm -rf /tmp/* /var/cache/apk/*
EOF

COPY --chmod=755 entrypoint.sh /usr/local/bin/
COPY --chmod=755 --from=go-downloader /go/bin/server /usr/local/bin/webtunnel-server

EXPOSE 15000 15000

VOLUME ["/var/lib/tor"]

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]
