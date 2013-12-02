#!/usr/bin/perl -w
#
# mutt_ldap_query.pl 
# version 1.2

#
# Historique
#   2001/09/12 : pda : conversion utf8
#

# Copyright (C) 4/14/98 Marc de Courville <marc@courville.org>
#       but feel free to redistribute it however you like.
#
# mutt_ldap_query.pl: perl script to parse the outputs of ldapsearch
# (ldap server query tool present in ldap-3.3 distribution
# http://www.umich.edu/~rsug/ldap) in order to pass the required
# formatted data to mutt (mail client http://www.mutt.org/)
# using Brandon Long's the "External Address Query" patch
# (http://www.fiction.net/blong/programs/mutt/#query).
#
# Warren Jones <wjones@tc.fluke.com> 2-10-99
#    o Instead of just matching "sn", I try to match these fields
#      in the LDAP database: "cn", "mail", "sn" and "givenname".
#      A wildcard is used to make a prefix match.  (I borrowed
#      this query from pine.)
#
#    o Commas separating command line arguments are optional.
#      (Does mutt really start up $query_command with comma
#      separated args?)
#
#    o Streamlined the perl here and there.  In particular,
#      I used paragraph mode to read in each match in a single
#      chunk.
#
#    o Added "use strict" and made the script "-w" safe.
#
#    o Returned non-zero exit status for errors or when there
#      is no match, as specified by the mutt docs.
#
#    o Explicitly close the pipe from ldapsearch and check
#      error status.
#  

use strict;

use Unicode::String qw(latin1 utf8);	# conversion latin1 <-> utf8
use MIME::Base64;

# Please change the following 2 lines to match your site configuration
#
my $ldap_server = "localhost";
my $BASEDN = "dc=gwarf, dc=org";           

# Fields to search in the LDAP database:
#
my @fields = qw(cn mail sn givenname);

die "Usage: $0 <name_to_query>, [[<other_name_to_query>], ...]\n"
    if ! @ARGV;

$/ = '';	# Paragraph mode for input.
my @results;

foreach my $askfor ( @ARGV ) {

    $askfor =~ s/,$//;	# Remove optional trailing comma.

    my $query = join '', map { "($_=$askfor*)" } @fields;
    my $command = "ldapsearch -x -L -h $ldap_server -b '$BASEDN' '(|$query)'" .
                  " sn givenName mail telephoneNumber";

    # print "$command\n";
    open( LDAPQUERY, "$command |" ) or die "LDAP query error: $!"; 

    while ( <LDAPQUERY> ) {
	# print "[$_]\n";

	my $parag = $_ ;
	while ($parag =~ /^([a-z]+):: (.*)$/im)
	{
	    my $attr = $1 ;
	    my $val = $2 ;
	    $val = utf8(decode_base64($val))->latin1 ; 
	    $parag =~ s/$1:: $2/$attr: $val/im ;
	    $_ = $parag ;
	    # print "$_\n";
	}

	next if ! /^mail: *(.*)$/im;
	my $email = $1;
	my $phone = /^telephoneNumber: *(.*)$/im ? $1 : '';
	my ( @name ) = ( /^givenName: *(.*)$/im, /^sn: *(.*)$/im );
	push @results, "$email\t@name\t$phone\n";
    }

    close( LDAPQUERY ) or die "ldapsearch failed: $!\n";
}

print "LDAP query: found ", scalar(@results), "\n", @results;
exit 1 if ! @results;
