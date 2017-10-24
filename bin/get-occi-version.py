#!/usr/bin/env python

import re

import keystoneclient.v2_0.client as ksclient
import novaclient.client
import requests

from six.moves.urllib.parse import urlparse

os_username = 'readall'
os_password = 'test'
os_tenant_name = 'fedcloud'
os_auth_url = 'https://192.168.56.105:5000/v2.0'
endpoint_url = 'https://192.168.56.105:8787/occi1.1'
os_cacert = '/etc/plop'

insecure = True

requests.packages.urllib3.disable_warnings()

client_cls = novaclient.client.Client
api = client_cls(2,
                 os_username,
                 os_password,
                 os_tenant_name,
                 auth_url=os_auth_url,
                 insecure=insecure)

api.authenticate()

keystone = ksclient.Client(auth_url=os_auth_url,
                           username=os_username,
                           password=os_password,
                           tenant_name=os_tenant_name,
                           insecure=insecure)
auth_token = keystone.auth_token

try:
    headers = {'X-Auth-token': auth_token}
    request_url = "%s/-/" % endpoint_url
    print('Requesting %s' % request_url)
    if insecure:
        verify = False
    else:
        verify = os_cacert
    r = requests.get(request_url, headers=headers, verify=verify)
    if r.status_code == requests.codes.ok:
        header_server = r.headers['Server']
        e_middleware_version = re.search(r'ooi/([0-9.]+)',
                                         header_server).group(1)
        e_version = re.search(r'OCCI/([0-9.]+)',
                              header_server).group(1)
        print("Version: %s, Middleware version: %s" % (e_version,
            e_middleware_version))
    else:
        print(r.text)
except requests.exceptions.RequestException as e:
    print(e)
    pass
except IndexError as e:
    print(e)
    pass
