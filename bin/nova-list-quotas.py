#!/usr/bin/env python
#
# https://www.ibm.com/developerworks/cloud/library/cl-openstack-pythonapis/

from credentials import get_nova_creds

import novaclient.client

import requests

requests.packages.urllib3.disable_warnings()

creds = get_nova_creds()

client_cls = novaclient.client.Client
nova = client_cls(2,
                  creds['username'],
                  creds['api_key'],
                  creds['project_name'],
                  auth_url=creds['auth_url'],
                  insecure=True)
nova.authenticate()

quotas = nova.quotas

print("Default instances: %s" % getattr(quotas.defaults(creds['project_id']), 'instances'))
print("Project instances: %s" % getattr(quotas.get(creds['project_id']), 'instances'))
