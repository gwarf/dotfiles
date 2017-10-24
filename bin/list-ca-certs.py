#!/usr/bin/env python2

import base64
import ssl
import socket
import pprint

#host = '192.168.56.105'
host = 'keystone.ifca.es'
port = 5000

context = ssl.SSLContext(ssl.PROTOCOL_SSLv23)
context.verify_mode = ssl.CERT_NONE
context.check_hostname = False
context.load_verify_locations('/etc/ssl/certs/ca-certificates.crt')

conn = context.wrap_socket(socket.socket(socket.AF_INET), server_hostname=host)
conn.do_handshake_on_connect = True

conn.connect((host, port))

print(conn.cipher())
print(conn.version())

cert = ssl.get_server_certificate((host, port))

import cryptography
from cryptography import x509
from cryptography.hazmat.backends import default_backend

der = ssl.PEM_cert_to_DER_cert(cert)
cert = x509.load_der_x509_certificate(der, default_backend())
pprint.pprint(cert)

stats = context.session_stats()
pprint.pprint(stats)

conn.sendall(b"OPTIONS / HTTP/1.0\r\nHost: localhost\r\n\r\n")

print("Connection information")
pprint.pprint(conn.recv(1024).split(b"\r\n"))

conn.close()
