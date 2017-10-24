#!/usr/bin/env python

#os_username = 'admin'
#os_password = 'test'
#os_tenant_name = 'admin'
os_username = 'readall'
os_password = 'test'
os_tenant_name = 'fedcloud'
os_auth_url = 'https://192.168.56.105:5000/v2.0'
insecure = True

import novaclient.client
#from novaclient.v2 import quotas
#from six.moves.urllib.parse import urlparse
## from novaclient import api_versions
import keystoneclient.v2_0.client as ksclient

import pprint

import prettytable
import six
from oslo_utils import encodeutils

import requests

requests.packages.urllib3.disable_warnings()

client_cls = novaclient.client.Client
api = client_cls(2,
                 os_username,
                 os_password,
                 os_tenant_name,
                 auth_url=os_auth_url,
                 insecure=insecure)

api.authenticate()

#pprint.pprint(dir(api))

keystone = ksclient.Client(auth_url=os_auth_url,
                           username=os_username,
                           password=os_password,
                           tenant_name=os_tenant_name,
                           insecure=insecure)
auth_token = keystone.auth_token
pprint.pprint(dir(keystone))
pprint.pprint(keystone.__dict__)
pprint.pprint(keystone.get_project_id(os_tenant_name))

#quotas = api.quotas
# XXX Here we should pass the ID, not the name!
#print("Default instances: %s" % getattr(quotas.defaults(os_tenant_name), 'instances'))
#print("Project  instances: %s" % getattr(quotas.get(os_tenant_name), 'instances'))

# Keystoneauth1
from keystoneauth1 import session
from keystoneauth1 import loading
from novaclient import client

import requests

requests.packages.urllib3.disable_warnings()

loader = loading.get_plugin_loader('password')
auth = loader.load_from_options(auth_url=os_auth_url,
                                username=os_username,
                                password=os_password,
                                project_name=os_tenant_name)
sess = session.Session(auth=auth, verify=False)
nova = client.Client('2.0', session=sess)

#pprint.pprint(sess.__dict__)
#pprint.pprint(sess.auth.__dict__)

#pprint.pprint(auth.get_project_id(sess))
pprint.pprint(sess.get_project_id())

#pprint.pprint(nova.__dict__)
#pprint.pprint(nova.client.__dict__)

# print("Default instances: %s" % getattr(nova.quotas.defaults(os_tenant_name), 'instances'))
# print("Project  instances: %s" % getattr(nova.quotas.get(os_tenant_name), 'instances'))


# Keystoneauth1 v3
# from keystoneauth1.identity import v3
# from keystoneauth1 import session
# from keystoneclient.v3 import client
# 
# auth = v3.Password(auth_url=os_auth_url,
#                    username=os_username,
#                    password=os_password,
#                    project_name=os_tenant_name)
# 
# sess = session.Session(auth=auth, verify=False)


#from novaclient import client
#
#from keystoneauth1.identity import generic
#from keystoneauth1 import session as keystone_session
#
#auth = generic.Password(auth_url=os_auth_url,
#                        username=os_username,
#                        password=os_password,
#                        project_name=os_tenant_name,
#                        project_domain_id='default',
#                        user_domain_id='default')
#
#session = keystone_session.Session(auth=auth)
#
#ks = client.Client('2.0', session=session)

#print(ks.__dict__)

#users = ks.client.users.list()

#images = ks.images.list()

#cs = novaclient.client.SessionClient(session=sess)


#q = api.quotas.get('fedcloud')
#print(q)

#for image in api.images.list(detailed=True):
#    print(image.name)

# catalog = api.client.service_catalog.catalog
#
# endpoints = catalog['access']['serviceCatalog']
# for endpoint in endpoints:
#     if endpoint['type'] == 'compute':
#         for ept in endpoint['endpoints']:
#             endpoint_url = ept['publicURL']
#             version = urlparse(endpoint_url).path.split('/')[1]
#             print('%s: %s' % (endpoint_url, version))
# version h
# #version = api.client.versions.get_current()
# print(version)

#r = requests.get("http://192.168.56.105:8787/occi1.1')
#if r.status_code == requests.codes.ok:
#     res = r.json()
#     print(res)
#     version = res['version']['id']
#     print(version)
#else:
#     print('Unable to retrieve version:  %s' % r.text)


# endpoint_url = 'https://192.168.56.105:8787/occi1.1'
# 
# try:
#     headers = {'X-Auth-token': self.auth_token}
#     request_url = "%s/-/" % endpoint_url
#     print('Requesting %s' % request_url)
#     r = requests.get(request_url, headers=headers)
#     if r.status_code == requests.codes.ok:
#         header_server = r.headers['Server']
#         e_middleware_version = re.search(r'ooi/([0-9.]+)',
#                                          header_server).group(1)
#         e_version = re.search(r'OCCI/([0-9.]+)',
#                               header_server).group(1)
# except requests.exceptions.RequestException as e:
#     print(e)
#     pass
# except IndexError:
#     pass

# import requests
# # X-Auth-token
# headers = {'X-Auth-token': auth_token}
# r = requests.get("http://192.168.56.105:8787/occi1.1/-/", headers=headers)
# if r.status_code == requests.codes.ok:
#      # print(r.text)
#      print(r.headers['Server'].split(' ')[1].split('/')[1])
#      #version = res['version']['id']
#      #print(version)
# else:
#     print('Error: %s' % r.text)

#vms = api.servers.list()
#for vm in vms:
#    image = api.images.find(id=vm.image['id'])
#    flavor = api.flavors.find(id=vm.flavor['id'])
#    print("%s (%s): %s - %s: %s" % (vm.name, vm.id, image.name, flavor.name,
#        vm.status))
