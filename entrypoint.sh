#!/bin/sh

# config xray
cat << EOF > /etc/config.json
{
  "inbounds":[
    {
      "port": 8888,
      "protocol": "vmess",
      "settings": {
        "decryption": "none",
        "clients": [
          {
            "id": "342e3fef-ade1-4c30-86ec-f21695ca9fd4"
          }
        ]
      },
      "streamSettings": {
        "network": "ws"
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}	
EOF

# run xray
/usr/bin/xray run -config /etc/config.json
