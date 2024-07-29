#!/usr/bin/env -S perl -n

# FIXME: when showing full headers we shouldn't change them

use Date::Parse;
use POSIX;
use strict;

while (<>) {
  if (/^Date: (.*)$/) {
      my $datestr = $1;
      my $date = strftime ("%a, %d %b %Y %H:%M:%S",
                          localtime (str2time ($datestr)));
      print "Date: $date\n";
  } else {
    print;
  }
}
