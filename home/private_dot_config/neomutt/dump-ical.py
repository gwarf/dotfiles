#!/usr/bin/env python
# https://github.com/simonjbeaumont/.dotfiles/blob/ce081a65/mutt/dump-ical.py

import sys
import warnings
import vobject


def get_invitation_from_path(path):
    with open(path) as f:
        try:
            # vobject uses deprecated Exceptions
            with warnings.catch_warnings():
                warnings.simplefilter("ignore")
                return vobject.readOne(f, ignoreUnreadable=True)
        except AttributeError:
            return vobject.readOne(f, ignoreUnreadable=True)


def person_string(c):
    if 'CN' in c.params:
        person = "%s %s" % (c.params['CN'][0], "<%s>" % c.value.split(':')[1])
    else:
        person = "<%s>" % c.value.split(':')[1]
    return person


def when_str_of_start_end(s, e):
    date_format = "%a, %d %b %Y at %H:%M"
    until_format = "%H:%M" if s == e else date_format
    return "%s -- %s" % (s.strftime(date_format), e.strftime(until_format))


def pretty_print_invitation(invitation):
    event = invitation.vevent.contents
    title = event['summary'][0].value
    org = event['organizer'][0]
    invitees = event['attendee']
    start = event['dtstart'][0].value
    end = event['dtend'][0].value
    location = event['location'][0].value
    description = event['description'][0].value
    print("="*70)
    print("MEETING INVITATION".center(70))
    print("="*70)
    print("Event:\n\t%s" % title)
    print("Organiser:\n\t%s" % person_string(org))
    print("Invitees:")
    for i in invitees:
        print("\t%s" % person_string(i))
    print("When:\n\t%s" % when_str_of_start_end(start, end))
    print("Location:\n\t%s" % location)
    print("---\n%s---" % description)


if __name__ == "__main__":
    if len(sys.argv) != 2 or sys.argv[1].startswith('-'):
        sys.stderr.write("Usage: %s <filename.ics>\n" % sys.argv[0])
        sys.exit(2)
    inv = get_invitation_from_path(sys.argv[1])
    pretty_print_invitation(inv)
