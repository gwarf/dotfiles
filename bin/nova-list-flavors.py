#!/usr/bin/env python
#
# https://www.ibm.com/developerworks/cloud/library/cl-openstack-pythonapis/

import os
import time
import novaclient.client
from credentials import get_nova_creds

creds = get_nova_creds()

client_cls = novaclient.client.Client
nova = client_cls(2,
                  creds['username'],
                  creds['api_key'],
                  creds['project_id'],
                  auth_url=creds['auth_url'],
                  insecure=True)
nova.authenticate()

for flavor in nova.flavors.list(detailed=True):
    #print(image_id)
    #print(image.metadata.items())
    #print(image.size)
    #print(flavor)
    print(flavor.name)
    #print(flavor.metadata)
    print(flavor.disk)
    print(flavor.ephemeral)

