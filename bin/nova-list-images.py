#!/usr/bin/env python
#
# https://www.ibm.com/developerworks/cloud/library/cl-openstack-pythonapis/

import os
import time
import novaclient.client
from credentials import get_nova_creds

import requests

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

for image in nova.images.list(detailed=True):
    image_id = image.id
    #print(image_id)
    #print(image.metadata.items())
    #print(image.size)
    img = nova.images.find(id=image.id)
    print(img)
    print(img.name)
    #print(img.size)
    print(img.metadata)
    # print("%s: %s - %s" % (image.id, image.name, image.size))
