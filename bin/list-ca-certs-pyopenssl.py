#!/usr/bin/env python2

host = '192.168.56.105'
port = 5000
insecure = True
#port = 8774

# host = 'keystone.ifca.es'
# port = 5000


import socket
import pprint

from OpenSSL import SSL
import cryptography
from cryptography.x509 import Name
from OpenSSL.crypto import X509
#from OpenSSL import SSL, crypto
#from OpenSSL.SSL import Context, TLSv1_METHOD, VERIFY_PEER, Connection, WantReadError

def verify_cb(conn, cert, errnum, depth, ok):
    return ok

if insecure:
    verify = SSL.VERIFY_NONE
else:
    verify = SSL.VERIFY_PEER

# Initialize context
ctx = SSL.Context(SSL.SSLv23_METHOD)
ctx.set_options(SSL.OP_NO_SSLv2)
ctx.set_options(SSL.OP_NO_SSLv3)
#ctx.set_verify(SSL.VERIFY_NONE, verify_cb)
ctx.set_verify(verify, lambda conn, cert, errnum, depth, ok: ok)
#ctx.set_verify(SSL.VERIFY_PEER, verify_cb)
if not insecure:
    ctx.load_verify_locations('/etc/ssl/certs/ca-certificates.crt')

# Set up client
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect((host, port))

client_ssl = SSL.Connection(ctx, client)
client_ssl.set_connect_state()

#client_ssl.connect((host, port))
#client_ssl.send('0')

client_ssl.set_tlsext_host_name(host)
client_ssl.do_handshake()

cert = client_ssl.get_peer_certificate()
#pprint.pprint(cert.__dict__)
#subject = client_ssl.get_peer_certificate().get_subject()
#subject_str = str(subject)
#pprint.pprint(subject_str[subject_str.find("'"):subject_str.rfind("'") + 1])
#common_name = subject.commonName
#print("Server: %s" % common_name)
#cert_chain = client_ssl.get_peer_cert_chain()
issuer = cert.get_issuer()
#pprint(issuer)
print("Issuer cert: %s" % type(issuer))

#last_cert = cert_chain[-1]
#print("Root issuer cert: %s" % last_cert.get_issuer().commonName)

client_ca_list = client_ssl.get_client_ca_list()
print('Client CAs size: %s' % len(client_ca_list))
trusted_cas = [str(ca)[18:-2] for ca in client_ca_list]
#pprint.pprint(trusted_cas)
#for ca in client_ca_list:
#    #dn = str(ca)
#    dn = str(ca)
##    #cert = cryptography.x509.Name(ca)
#    pprint.pprint(dn)
##    # XXX shortest way to get the DN, as __repr__ is
##    # <X509Name object 'DN>'
#    pprint.pprint(str(dn)[dn.find("'"):dn.rfind("'") + 1])
#    pprint.pprint(dn[17:-1])
##    #print ca.commonName
##    #print ca._name
##    #components = ca.get_components()
##    #pprint.pprint(components)
##    #print ca.name.get_components()['name']
##    #subject = ca.get_subject().commonName
#
##pprint.pprint(client_ca_list)

client_ssl.shutdown()
client_ssl.close()
