#!/usr/bin/env python
#
# https://www.ibm.com/developerworks/cloud/library/cl-openstack-pythonapis/

import os
import time
import novaclient.client
import requests

from credentials import get_nova_creds
from six.moves.urllib.parse import urlparse

requests.packages.urllib3.disable_warnings()

creds = get_nova_creds()

client_cls = novaclient.client.Client
nova = client_cls(2,
                  creds['username'],
                  creds['api_key'],
                  creds['project_id'],
                  auth_url=creds['auth_url'],
                  insecure=True)
nova.authenticate()

catalog = nova.client.service_catalog.catalog

endpoints = catalog['access']['serviceCatalog']
for endpoint in endpoints:
    if endpoint['type'] == 'compute':
        print(endpoint)
        for ept in endpoint['endpoints']:
            #print(ept)
            endpoint_url = ept['publicURL']
            version = urlparse(endpoint_url).path.split('/')[1]
            #print('%s: %s' % (endpoint_url, version))
