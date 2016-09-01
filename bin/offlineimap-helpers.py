#!/usr/bin/python

import re
import sys
import gtk
import gnomekeyring as gkey

class Keyring(object):
    def __init__(self, name, server, protocol):
        self._name = name
        self._server = server
        self._protocol = protocol
        self._keyring = gkey.get_default_keyring_sync()

    def has_credentials(self):
        try:
            attrs = {"server": self._server, "protocol": self._protocol}
            items = gkey.find_items_sync(gkey.ITEM_NETWORK_PASSWORD, attrs)
            return len(items) > 0
        except gkey.DeniedError:
            return False

    def get_credentials(self):
        attrs = {"server": self._server, "protocol": self._protocol}
        items = gkey.find_items_sync(gkey.ITEM_NETWORK_PASSWORD, attrs)
        return (items[0].attributes["user"], items[0].secret)

    def set_credentials(self, (user, pw)):
        attrs = {
                "user": user,
                "server": self._server,
                "protocol": self._protocol,
            }
        gkey.item_create_sync(gkey.get_default_keyring_sync(),
                gkey.ITEM_NETWORK_PASSWORD, self._name, attrs, pw, True)

def get_username(server):
    keyring = Keyring("offlineimap", server, "imap")
    (username, password) = keyring.get_credentials()
    return username

def get_password(server):
    keyring = Keyring("offlineimap", server, "imap")
    (username, password) = keyring.get_credentials()
    return password

def oimaptransfolder_gmx(foldername):
    if(foldername == "INBOX"):
        retval = "gmx"
    else:
        retval = "gmx." + foldername
    retval = re.sub("/", ".", retval)
    return retval

def oimaptransfolder_mpi(foldername):
    if(foldername == "INBOX"):
        retval = "mpi"
    else:
        retval = "mpi." + foldername
    retval = re.sub("/", ".", retval)
    return retval

def oimaptransfolder_gentoo(foldername):
    if(foldername == "INBOX"):
        retval = "gentoo"
    else:
        retval = re.sub("INBOX.", "", foldername)
        retval = "gentoo." + retval
    retval = re.sub("/", ".", retval)
    return retval

def oimaptransfolder_gmail(foldername):
    # Inbox has the normal name, all other have trailing '[Gmail]'
    if(foldername == "INBOX"):
        retval = "gmail"
    else:
        retval = "gmail." + foldername
    # Now replace any funny gmails that gmail put there
    retval = re.sub("\[Gmail\].", "", retval)
    retval = re.sub("/", ".", retval)
    return retval

