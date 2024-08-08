#!/usr/bin/env python2

"""
Set/get passwords for MSMTP or MPOP in Gnome Keyring

Copyright (C) 2009 Gaizka Villate
              2010 Emmanuel Bouthenot

Original author: Gaizka Villate <gaizkav@gmail.com>
Other author(s): Emmanuel Bouthenot <kolter@openics.org>

URL: http://github.com/gaizka/misc-scripts/tree/master/msmtp

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.  See http://www.gnu.org/copyleft/gpl.html for
the full text of the license.
"""

import sys, os.path, optparse, getpass

try:
    import gnomekeyring as gk
except ImportError:
    print("""Unable to import gnome keyring module""")
    sys.exit(-1)

class keyringManager():

    def __init__(self):
        # get default keyring name
        try:
            self.keyring = gk.get_default_keyring_sync()
        except gk.nokeyringdaemonerror:
            print("err: can't open gnome keyring")
            print("are you running this program under a gnome session ?")
            sys.exit(-1)

    def set(self, user, password, server, protocol, app):
        # display name for password.
        display_name = '%s password for %s at %s' % (app.upper(), user, server)

        # select type. if you want some kind of "network" password, it seems that
        # appropriate type is network_password because it has a schema already.
        type = gk.ITEM_NETWORK_PASSWORD

        usr_attrs = {'user':user, 'server':server, 'protocol':protocol}

        # now it gets ready to add into the keyring. do it.
        # its id will be returned if success or an exception will be raised
        id = gk.item_create_sync(self.keyring, type, display_name, usr_attrs, password, False)
        return id is not None

    def get(self, user, server, protocol, app):
        try:
            results = gk.find_network_password_sync(user=user, server=server, protocol=protocol)
        except gk.NoMatchError:
            return None

        return results[0]["password"]

    def getpass(self, username, server, protocol, app):
        ret = True
        passwd = self.get(username, server, protocol, app)
        if passwd is None:
            print("no password set for user '%s' in server '%s'" % (username, server))
            ret = False
        else:
            print(passwd)

        return ret

    def setpass(self, username, server, protocol, app):
        ret = True
        # does it already exist?
        if self.get(username, server, protocol, app) is not None:
            print("err: %s password for user '%s' in server '%s' already exists, try do delete it first" \
                    % (app.upper(), username, server))
            ret = False
        else:
            msg = "password for user '%s' in server '%s' ? " %(username, server)
            passwd = getpass.getpass(msg)
            passwd_confirmation = getpass.getpass("confirmation ? ")
            if passwd != passwd_confirmation:
                print( "err: password and password confirmation mismatch")
                ret = False
            else:
                if self.set(username, passwd, server, protocol, app):
                    print("password successfully set")
                else:
                    print("err: password failed to set")
                    ret = False

        return ret

    def delpass(self, username, server, protocol):
        ret = True
        # does it already exist?
        try:
            results = gk.find_network_password_sync(user=username, server=server, protocol=protocol)
        except gk.NoMatchError:
            print("no password set for user '%s' in server '%s'" % (username,
                    server))
            ret = False

        if ret:
            gk.item_delete_sync(self.keyring, results[0]['item_id'])
            print("password successfully removed")

        return ret

def main():
    ret = True
    km = keyringManager()

    parser = optparse.OptionParser(usage="%prog [-s|-g|-d] --username myuser --server myserver --protocol myprotocol --app myapp")
    parser.add_option("-s", "--set-password", action="store_true", \
            dest="setpass", help="set password")
    parser.add_option("-g", "--get-password", action="store_true", \
            dest="getpass", help="get password")
    parser.add_option("-d", "--del-password", action="store_true", \
            dest="delpass", help="delete password")
    parser.add_option("-u", "--username", action="store", dest="username", \
            help="username")
    parser.add_option("-e", "--server", action="store", dest="server", \
            help="smtp server")
    parser.add_option("-a", "--app", action="store", dest="app", \
            help="Application name (msmtp, mbsync,...)")
    parser.add_option("-p", "--protocol", action="store", dest="protocol", \
            help="Protocol name")

    (opts, args) = parser.parse_args()

    if not opts.setpass and not opts.getpass and not opts.delpass:
        parser.print_help()
        print("err: you have to use -s or -g or -d")
        ret = False
    elif not opts.username or not opts.server:
        parser.print_help()
        print("err: you have to use both --username and --server")
        ret = False
    elif opts.getpass:
        ret = km.getpass(opts.username, opts.server, opts.protocol, opts.app)
    elif opts.setpass:
        ret = km.setpass(opts.username, opts.server, opts.protocol, opts.app)
    elif opts.delpass:
        ret = km.delpass(opts.username, opts.server, opts.protocol)
    else:
        print("err: unknown option(s)")
        ret = False

    return ret

if __name__ == '__main__':
    if main():
        sys.exit(0)
    else:
        sys.exit(-1)

