#!/bin/sh
#
# Copyright (C) 2017 TDT GmbH
#
# This is free software, licensed under the GNU General Public License v2.
# See https://www.gnu.org/licenses/gpl-2.0.txt for more information.
#
########################################################################


apikey=""
userkey=""
device=""


VERSION="1.0"
PROGNAME="$(basename $0)"

. /lib/functions.sh
. /usr/share/libubox/jshn.sh

log() {
logger -p daemon.debug -t "Skript" "$1"
}



print_usage () {
    cat <<EOT
Usage:  ${PROGNAME} -u <user key> -a <api key> [<options>] -t "Titel" -m "Nachricht"
Supported options:
    -h              Hilfe anzeigen
    -v              Version anzeigen
    -u  <user key>  user key (nicht die E-Mail Adressenot) - Kann im Programm hinterlegt werden
    -a  <api key>   application's API token - Kann im Programm hinterlegt werden
    -m  <message>   Nachricht, welche gesendet wird. Muss in Anfuehrungszeichen eingegeben werden
    -d  <device>    Device an welches die Nachricht gesendet wird - Kann im Programm hinterlegt werden
    -q  <title>     Titel der Nachricht. Muss in Anfuehrungszeichen eingegeben werden
    -p  <priority>  Prioritaet der Nachricht (Wert von -2 bis 2 moeglich
                    2 entspricht der hoechsten und -2 der niedrigsten Prioritaet

Beispiel -t "Testtitel" -m "Nachricht von Max Mustermann" -d "Handy von Max"


EOT
}


COMMAND_PARAM=":vhlp:m:t:d:u:a:"
 
# falls nicht Uebergeben wurden mit exit beenden
if ( ! getopts "${COMMAND_PARAM}" opt); then
    #echo "Usage: `basename $0` options -t Titel der Nachricht / use -h for help";
    print_usage
    exit 1;
fi
 
# Parameter auswerten
 
while getopts "${COMMAND_PARAM}"  opt; do
  case $opt in
    l)
	lvar="1"
	>&2
	;;
    m)
	mvar="$OPTARG"
	>&2
     	;;
    t)
	tvar="$OPTARG"
	>&2
	;;  
    p)
        pvar="$OPTARG"
        >&2
	;;
    u)
        uvar="$OPTARG"
        >&2
	;;
    a)
        avar="$OPTARG"
        >&2
	;;
    d)
        dvar="$OPTARG"
        >&2
      	;;
    v)
	echo "${PROGNAME} ${VERSION}"
	exit
	>&2
      	;;

    h)
        print_usage
	exit
	>&2
      	;;
    \?)
      	echo "Invalid option: -$OPTARG" >&2
      	exit 1
      	;;
    :)
      	echo 'Option '-$OPTARG' requires an argument. '${PROGNAME}' -h fuer Hilfe' >&2
      	exit 1
      	;;
  esac
done

# Standardwert setzen falls keine Option mitgegeben wurde aber der Wert benoetigt wird
if [ -z "$tvar" ] ;then echo "Titel -t MUSS gesetzt werden. Hilfe mit -h" ; exit ;fi
if [ -z "$mvar" ] ;then mvar=$tvar ;fi
if [ -z "$pvar" ] ;then pvar="0" ;fi
if [ "$pvar" -gt 1 ] || [ "$pvar" -lt -2 ] ;then echo "Es werden nur Werte zwischen -2 und 1 unterstuetzt. Hilfe mit -h" ; exit ;fi
if [ -z "$lvar" ] ;then : ;else log "Pushover-Nachricht: Titel:$tvar, Nachricht:$mvar, Prioritaet:$pvar, an Device:$dvar" ;fi
if [ -z "$dvar" ] ;then dvar=$device ;fi
if [ -z "$uvar" ] ;then uvar=$userkey ;fi
if [ -z "$avar" ] ;then avar=$apikey ;fi
if [ -z "$pvar" ] ;then pvar="0" ;fi
if [ -z "$uvar" ] ;then echo "Kein userkey gesetzt. Hilfe mit -h" ; exit ;fi
if [ -z "$avar" ] ;then echo "Kein apikey gesetzt. Hilfe mit -h" ; exit ;fi


# Senden der Nachricht via Pushover


if [ -z "$dvar" ]
then
	curl -s -k \-F "token=$avar" \-F "user=$uvar" \-F "message=$mvar" \-F "title=$tvar" \-F "priority=$pvar" \https://api.pushover.net/1/messages.json
else
        curl -s -k \-F "token=$avar" \-F "user=$uvar" \-F "message=$mvar" \-F "title=$tvar" \-F "priority=$pvar" \-F "device=$device" \https://api.pushover.net/1/messages.json
fi

