FROM golang:alpine AS builder
RUN apk update && apk add --no-cache git
WORKDIR /go/src/xray/core
RUN git clone --progress https://github.com/XTLS/Xray-core.git . && \
    go mod download && \
    CGO_ENABLED=0 go build -o /tmp/xray -trimpath -ldflags "-s -w -buildid=" ./main

FROM alpine:edge

ARG AUUID="342e3fef-ade1-4c30-86ec-f21695ca9fd4"
ARG CADDYIndexPage="https://github.com/AYJCSGM/mikutap/archive/master.zip"
ARG ParameterSSENCYPT="chacha20-ietf-poly1305"
ARG PORT=8080

COPY etc/Caddyfile /tmp/Caddyfile
COPY etc/config.json /tmp/config.json
COPY entrypoint.sh /entrypoint.sh
COPY --from=builder /tmp/xray /usr/bin

RUN apk update && \
    apk add --no-cache ca-certificates caddy tor wget && \
    ntpd -d -q -n -p 0.pool.ntp.org && \
    mkdir -p /etc/caddy/ /usr/share/caddy && echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt && \
    wget $CADDYIndexPage -O /usr/share/caddy/index.html && unzip -qo /usr/share/caddy/index.html -d /usr/share/caddy/ && mv /usr/share/caddy/*/* /usr/share/caddy/ && \
    cat /tmp/Caddyfile | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(caddy hash-password --plaintext $AUUID)/g" >/etc/caddy/Caddyfile && \
    cat /tmp/config.json | sed -e "s/\$AUUID/$AUUID/g" -e "s/\$ParameterSSENCYPT/$ParameterSSENCYPT/g" >/etc/config.json

RUN chmod +x /entrypoint.sh

CMD /entrypoint.sh
