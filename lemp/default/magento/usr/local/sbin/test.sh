#!/bin/bash

SSL_CONFIG_FILE="/etc/nginx/conf.d/ssl.conf.disabled"
LOG_FILE="/var/log/run.log"

if [ -f "$SSL_CONFIG_FILE" ]; then
    echo "$(date): Removing QUIC support..." | tee -a "$LOG_FILE"
    sed -i '/listen\s\+443\s\+quic/d; /listen\s\+\[::\]:443\s\+quic/d' "$SSL_CONFIG_FILE"
    echo "$(date): QUIC support removed from $SSL_CONFIG_FILE" | tee -a "$LOG_FILE"
fi
