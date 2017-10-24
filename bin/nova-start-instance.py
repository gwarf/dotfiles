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
                  insecure=creds['insecure'])
nova.authenticate()

if not nova.keypairs.findall(name="mykey"):
    with open(os.path.expanduser('~/.ssh/id_rsa.pub')) as fpubkey:
        nova.keypairs.create(name="mykey", public_key=fpubkey.read())
image = nova.images.find(name="cirros")
flavor = nova.flavors.find(name="m1.tiny")
instance = nova.servers.create(name="test_halted", image=image, flavor=flavor, key_name="mykey")

# Poll at 5 second intervals, until the status is no longer 'BUILD'
status = instance.status
while status == 'BUILD':
        time.sleep(5)
        # Retrieve the instance again so the status
        # field updates
        instance = nova.servers.get(instance.id)
        status = instance.status

print "status: %s" % status

# instance.suspend()
# while status != 'SUSPENDED':
#         time.sleep(5)
#         # Retrieve the instance again so the status
#         # field updates
#         instance = nova.servers.get(instance.id)
#         status = instance.status
# print "status: %s" % status

instance.stop()
while status == 'ACTIVE':
        time.sleep(5)
        # Retrieve the instance again so the status
        # field updates
        instance = nova.servers.get(instance.id)
        status = instance.status
print "status: %s" % status
