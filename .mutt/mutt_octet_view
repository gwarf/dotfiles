#!/bin/sh
# @(#) mutt_octet_view $Revision: 1.1 $

#   mutt_octet_view - select octet-stream e-mail attachment viewer
#   Copyright (C) 1997,1998,1999,2000 David A Pearson
#   Copyright (C) 2000-2001 Gary A. Johnson
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

# Mutt_octet_view is derived from Dave Pearson's mutt.octet.filter
# script (http://www.hagbard.demon.co.uk/archives/mutt.octet.filter).
# Mutt.octet.filter was designed to convert octet-stream e-mail
# attachments to text for use with mutt's auto_view feature.
# Mutt_octet_view extends this capability to use different viewers from
# mutt's attachment menu, including graphical viewers if X is available.
#
# To use mutt_octet_view, put the following lines in your mailcap file:
#
#   application/octet-stream; mutt_octet_view -x %s; test=RunningX
#   application/octet-stream; mutt_octet_view -v %s
#   application/octet-stream; mutt_octet_view %s; copiousoutput
#
# and the following line in your muttrc file:
#
#   auto_view application/octet-stream 
#
# Mutt_octet_view is not a viewer itself; it only selects external
# viewers based on the attachments' file name suffixes (extensions).
# In addition to any viewers, you will need a copy of the author's
# mutt_bgrun script in order to run X viewers in the background.
#
# Please direct any comments to:
#
#   Gary Johnson <garyjohn@spk.agilent.com>
#


ShowTAR()
{
    tar tvvf "$1" 2> /dev/null
}

ShowTGZ()
{
    tar tzvvf "$1" 2> /dev/null
}

ShowTBZ()
{
    bzip2 -dc "$1" | tar -tvv -f- 2> /dev/null
}

ShowGZIP()
{
    gzip -dc "$1" 2> /dev/null
}

ShowZIP()
{
    unzip -l "$1" 2> /dev/null
}

ShowARJ()
{
    unarj l "$1" 2> /dev/null
}

ShowVCard()
{
    cat "$1" | mutt.vcard.filter
}

ShowTIF()
{
    tiffinfo "$1"
}

ShowObject()
{
    nm "$1"
}

ShowHTML()
{
    w3m -dump "$1"
}

ShowPDF()
{
    pdftotext "$1" -
}

Show()
{
    case "$Mode" in
    SHOW)
	if [ "$2" ]
	then
	    $2 "$1"
	elif [ "$3" -o "$4" ]
	then
	    echo "[-- $Prog: file type is unsupported for autoview (use 'v' to view this part) --]"
	else
	    echo "[-- $Prog: file type is unsupported --]"
	fi
	;;
    VIEW)
	if [ "$3" ]
	then
	    $3 "$1"
	elif [ "$2" ]
	then
	    $2 "$1"
	else
	    echo "$Prog: file type is unsupported" >&2
	    exit 1
	fi
	;;
    XVIEW)
	if [ "$4" ]
	then
	    mutt_bgrun $4 "$1" || $4 "$1"
	elif [ "$3" ]
	then
	    $3 "$1"
	elif [ "$2" ]
	then
	    $2 "$1"
	else
	    echo "$Prog: file type is unsupported" >&2
	    exit 1
	fi
	;;
    *)	echo "$Prog: internal error: invalid Mode $Mode" >&2
	exit 2;;
    esac
}

# Initialize variables

Prog=$(basename "$0")
Mode=SHOW

# Check option arguments

while [ $# -gt 0 ]
do
    case "$1" in
    -t)	Mode=SHOW; shift;;
    -v)	Mode=VIEW; shift;;
    -x)	Mode=XVIEW; shift;;
    -*)	echo "$Prog: invalid option $1" >&2; exit 2;;
    *)	break;;
    esac
done

# Check file argument

if [ $# -ne 1 ]
then
    echo "usage: $Prog [-t|-v|-x] file"
    exit 2
fi

File=$1

# Process file

# The behavior of mutt_octet_view is governed primarily by the 'Show'
# function, the option argument, and the table below.  'Show' searches
# its arguments for a command that it can use to display File.  It
# begins in the table column specified by the option argument -t (the
# default), -v or -x, and searches to the left until it finds a command
# (non-empty string), which it executes.  Commands in the right-most
# column are executed in the background and are left to handle their own
# output.  Commands  in the other two columns are executed in the
# foreground and send their output to stdout.
#
# Here are some examples.
#
#  Autoview     Text View     X View
#    (from        (from        (from
#    index     attachment   attachment
#    menu,        menu,        menu,
#  in-line)    foreground)  background)
#    (-t)         (-v)         (-x)
# -----------  -----------  -----------
# Func1        ""           ""           Func1 will be used to display
#                                        file in all cases.  This is
#                                        useful when all that is
#                                        required to display the file is
#                                        a simple text transformation.
#
# ""           Func2        ""           The file will not be displayed
#                                        in the pager output from the
#                                        index menu.  Func2 will be used
#                                        to display the file from the
#                                        attachment menu.  This is
#                                        useful when the file is to be
#                                        displayed as text, but is not
#                                        normally desired to view it
#                                        along with the rest of the
#                                        message.
#
# ""           ""           Func3        The file contains graphical
#                                        material that cannot be viewed
#                                        as text.  Func3 will be used to
#                                        display the file only from the
#                                        attachment menu and only when X is
#                                        available.  Func3  will be run in
#                                        the background so that the user
#                                        can continue to use the mailer
#                                        while the file is displayed.
#
# ""           Func2        Func3        The file contents are not
#                                        displayed in-line along with
#                                        the rest of the message because
#                                        the file is typically large.
#                                        Func2 has only text output and
#                                        is used when only a terminal is
#                                        available for output.  Func3
#                                        produces a nicer display when X
#                                        is available.

case "$File" in
		#                Autoview     Text View      X View
		#                  (from        (from         (from
		#                  index     attachment    attachment
		#                  menu,        menu,         menu,
		#                in-line)    foreground)   background)
		#                  (-t)         (-v)          (-x)
	        #               -----------  -----------  -------------
*.arj  | *.ARJ  ) Show "$File"  ""           ShowARJ      ""             ;;
*.doc  | *.DOC  ) Show "$File"  word2text    word2text    qvpview        ;;
*.gif  | *.GIF  ) Show "$File"  ""           ""           xv             ;;
*.htm  | *.HTM  ) Show "$File"  ShowHTML     w3m          mutt_netscape  ;;
*.html | *.HTML ) Show "$File"  ShowHTML     w3m          mutt_netscape  ;;
*.jpeg | *.JPEG ) Show "$File"  ""           ""           xv             ;;
*.jpg  | *.JPG  ) Show "$File"  ""           ""           xv             ;;
*.log  | *.LOG  ) Show "$File"  cat          less         ""             ;;
*.o             ) Show "$File"  ""           ShowObject   ""             ;;
*.pdf  | *.PDF  ) Show "$File"  ""           ShowPDF      acroread       ;;
*.ppt  | *.PPT  ) Show "$File"  ""           ""           qvpview        ;;
*.ps   | *.PS   ) Show "$File"  ""           ""           ghostview      ;;
*.rtf  | *.RTF  ) Show "$File"  ""           rtf2text     qvpview        ;;
*.tar           ) Show "$File"  ""           ShowTAR      ""             ;;
*.tar.bz2       ) Show "$File"  ""           ShowTBZ      ""             ;;
*.tar.gz        ) Show "$File"  ""           ShowTGZ      ""             ;;
*.tar.Z         ) Show "$File"  ""           ShowTGZ      ""             ;;
*.tar.z         ) Show "$File"  ""           ShowTGZ      ""             ;;
*.tbz2          ) Show "$File"  ""           ShowTBZ      ""             ;;
*.tgz           ) Show "$File"  ""           ShowTGZ      ""             ;;
*.tif  | *.TIF  ) Show "$File"  ""           ShowTIF      xv             ;;
*.txt  | *.TXT  ) Show "$File"  cat          less         ""             ;;
*.url  | *.URL  ) Show "$File"  cat          w3m          ""             ;;
*.vcf           ) Show "$File"  ""           ShowVCard    ""             ;;
*.xls  | *.XLS  ) Show "$File"  excel2text   excel2text   qvpview        ;;
*.Z             ) Show "$File"  ""           ShowGZIP     ""             ;;
*.z             ) Show "$File"  ""           ShowGZIP     ""             ;;
*.zip  | *.ZIP  ) Show "$File"  ""           ShowZIP      ""             ;;
*.gz            ) Show "$File"  ""           ShowGZIP     ""             ;;
		# The *.gz entry must follow any other entries ending in
		# .gz.
*               ) echo "$Prog: file type is unsupported" >&2; exit 1     ;;

esac
