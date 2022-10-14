#!/bin/sh

tor &
ntpd -d -q -n -p 0.pool.ntp.org &
/usr/bin/xray run -config /etc/config.json &
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
