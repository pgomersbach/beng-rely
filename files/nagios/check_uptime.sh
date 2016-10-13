#!/bin/sh
 
# check_uptime.sh
# Vanderlet, rdn, 20070115
# geeft uptime in dagen uren minuten
# minstens compatible met sles en rhel
#
# versie 0.1, 20080318: overgenomen uit buglist comment 070126-8
# versie 0.2, 20081117: variabelen beter gekozen, output uitgebreider
#
# TODO: threshold evaluation
 
if [ -f /opt/nrpe/bin/utils.sh ]
then
. /opt/nrpe/bin/utils.sh
fi
if [ -f /usr/local/nagios/libexec/utils.sh ]
then
. /usr/local/nagios/libexec/utils.sh
fi
if [ -f /usr/lib64/nagios/plugins/utils.sh ]
then
. /usr/lib64/nagios/plugins/utils.sh
fi
 
read uptime_sec idletime_sec < /proc/uptime
 
SEC=$(echo $uptime_sec | sed "s/\.[0-9]*//")
DGN=$(($SEC / 86400))
SEC=$(($SEC - $DGN * 86400))

URN=$(($SEC / 3600))
SEC=$(($SEC - $URN * 3600))

MIN=$(($SEC / 60))

if [ $SEC ]
then
    echo "System uptime ${DGN} day(s) ${URN} hour(s) ${MIN} minute(s)."
    exit ${STATE_OK}
else
    exit ${STATE_UNKNOWN}
fi

