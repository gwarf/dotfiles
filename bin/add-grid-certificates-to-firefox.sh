#!/bin/sh

# Adds CA certificates of /etc/grid-security/certificates to Firefox trustore

FIREFOX_CERT_DB=$(dirname $(find ~/.mozilla -type f -name 'cert8.db'))
CA_TRUST_LEVEL='CT,C,C'

for cert in /etc/grid-security/certificates/*.pem; do
  nickname=$(basename "${cert%%.pem}")
  certutil -d "$FIREFOX_CERT_DB" -A -i "$cert" -n "$nickname" -t "$CA_TRUST_LEVEL"
done
