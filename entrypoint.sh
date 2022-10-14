#!/bin/sh

tor &
/usr/bin/xray run -config /etc/config.json &
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
