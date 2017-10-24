#!/bin/sh

DOMAIN="$1"
CERTFILE="$DOMAIN.crt"

echo QUIT \
  | openssl s_client -connect "$DOMAIN:443" \
  | sed -ne "/BEGIN CERT/,/END CERT/w $CERTFILE"
