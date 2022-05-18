FROM alpine:3.15
#FROM arm64v8/alpine

ARG IMAGE_VERSION
ARG BUILD_DATE

LABEL org.opencontainers.image.created="$BUILD_DATE"
LABEL org.opencontainers.image.source="github.com/Telestosatt/openvpn-client-docker"
LABEL org.opencontainers.image.version="$IMAGE_VERSION"

ENV KILL_SWITCH=on \
    VPN_LOG_LEVEL=3 \
    HTTP_PROXY=off \
    SOCKS_PROXY=off \
    VPN_CONFIG_FILE=

RUN apk --no-cache --no-progress upgrade
RUN apk add --no-cache \
        bash \
        bind-tools \
        dante-server \
        openvpn \
        tinyproxy

RUN mkdir -p /data/vpn

COPY data/ /data

HEALTHCHECK CMD ping -c 3 1.1.1.1 || exit 1

ENTRYPOINT ["/data/scripts/entry.sh"]
