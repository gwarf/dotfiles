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

vms = nova.servers.list()
for vm in vms:
    image = nova.images.find(id=vm.image['id'])
    flavor = nova.flavors.find(id=vm.flavor['id'])
    print("%s (%s): %s - %s: %s" % (vm.name, vm.id, image.name, flavor.name,
        vm.status))
