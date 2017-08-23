#!/bin/sh

# Adds CA certificates of /etc/grid-security/certificates to Chromium trustore

CERT_DB="sql:$HOME/.pki/nssdb"
CA_TRUST_LEVEL='CT,C,C'

for cert in /etc/grid-security/certificates/*.pem; do
  nickname=$(basename "${cert%%.pem}")
  certutil -d "$CERT_DB" -A -i "$cert" -n "$nickname" -t "$CA_TRUST_LEVEL"
done
