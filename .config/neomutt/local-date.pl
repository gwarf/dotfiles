#!/usr/bin/env -S perl -n

use Date::Parse;
use POSIX;
use strict;

if (/^Date: (.*)$/) {
    my $datestr = $1;
    my $date = strftime ("%a, %d %b %Y %H:%M:%S",
                         localtime (str2time ($datestr)));
    print "Local-Date: $date\n";
}

print;
