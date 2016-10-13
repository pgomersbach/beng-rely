# Check available memory (Linux & Unix supported)
# VDL v2.1
# 2008/09/26 JMN added performance data that graphing tools like PNP will be able to use; add explanation in service output that reported value is "available mem"

PROGNAME=`basename $0`
PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`
. $PROGPATH/utils.sh
MEMSTAT=$PROGPATH/memstat

if [ -x /bin/bash ]
then
   ECHO=/bin/echo
   AWK=/bin/awk
   #! /bin/bash --posix
elif [ -x /usr/bin/ksh ]
then
   ECHO=/usr/bin/echo
   AWK=/usr/bin/awk
   #! /usr/bin/ksh
else
   echo "Could not locate KSH or BASH!"
   exit 3
fi

print_usage() {
  $ECHO "Usage:"
  $ECHO "  $PROGNAME WARN CRIT"
  $ECHO "  Where WARN is the value of Free space (in kB) to sent a Warning"
  $ECHO "  and CRIT is the value of Free space (in kB) to sent a Critical"
  $ECHO "  If percentages are used, end the values with a %-sign"
  $ECHO ""
  $ECHO "  $PROGNAME -h shows help info (this info!)"
}

print_help() {
  $ECHO ""
  print_usage
  $ECHO ""
  $ECHO "Checks memory usage; warns if percentage of free memory is less"
  $ECHO "than the given thresholds (WARN and CRIT)"
}

# Test number of commandline params, need 2 and if percentages are specified
if [ "$#" != "2" ]
then
   print_help
   exitstatus=$STATE_UNKNOWN ; exit $exitstatus
elif $ECHO $1|grep %>/dev/null && $ECHO $2|grep %>/dev/null
then
   PERC=yes
   # Remove the percentage-sign from the values
   WARN=`$ECHO $1|rev|cut -c 2- |rev`
   CRIT=`$ECHO $2|rev|cut -c 2- |rev`
elif ! $ECHO $1|grep % && ! $ECHO $2|grep %
then
   PERC=no
   WARN=$1
   CRIT=$2
else
   print_help
   exitstatus=$STAT_UNKNOWN ; exit $exitstatus
fi

# Test if WARN is higher than CRIT
if [ $WARN -le $CRIT ]
then
   $ECHO "Warning value/percentage should be higher than Critical value/percentage!"
   $ECHO ""
   exitstatus=$STATE_UNKNOWN ; exit $exitstatus
fi

# Test OS (currently HP-UX and Linux are supported)
OS=`uname -s`
case $OS in
   "Linux")
      TotalMem=`$AWK ' /MemTotal/ { print $2 }' /proc/meminfo`
      FreeMem=`$AWK ' /MemFree/ { print $2 }' /proc/meminfo`
   ;;
   "HP-UX")
      TotalMem=`$MEMSTAT|$AWK ' /Physical/ { printf "%i", ($6*1024) }'`
      FreeMem=`$MEMSTAT|$AWK ' /Free/ { printf "%i", ($6*1024) }'`
   ;;
   "*")
      $ECHO ""
      $ECHO "This plugin does not currently support OS: "$OS""
      $ECHO ""
      exitstatus=$STATE_UNKNOWN ; exit $exitstatus
   ;;
esac

# Define variable for Nagios Performance Data so it can be graphed by PNP/RRD
PERFDATA="|FreeMem=${FreeMem}kB;$WARN;$CRIT;0;"

# Do some Math
if [ "$PERC" = "yes" ]
then
   PERCENT=`$ECHO $FreeMem $TotalMem |$AWK '{ print int($1/$2*100) }'`
   if [ $PERCENT -gt $WARN ]
   then
      $ECHO "Memory level OK: ($FreeMem kB available), $PERCENT% ${PERFDATA}"
      exitstatus=$STATE_OK ; exit $exitstatus
   elif [ $CRIT -lt $PERCENT ] && [ $PERCENT -le $WARN ]
   then
      $ECHO "Memory level WARNING: ($FreeMem kB available), $PERCENT% ! ${PERFDATA}"
      exitstatus=$STATE_WARNING ; exit $exitstatus
   else
      $ECHO "Memory level CRITICAL: ($FreeMem kB available), $PERCENT% !!! ${PERFDATA}"
      exitstatus=$STATE_CRITICAL ; exit $exitstatus
   fi
else
   if [ $FreeMem -gt $WARN ]
   then
      $ECHO "Memory level OK: ($FreeMem kB available) ${PERFDATA}"
      exitstatus=$STATE_OK ; exit $exitstatus
   elif [ $CRIT -lt $FreeMem ] && [ $FreeMem -le $WARN ]
   then
      $ECHO "Memory level WARNING: ($FreeMem kB available) !! ${PERFDATA}"
      exitstatus=$STATE_WARNING ; exit $exitstatus
   else
      $ECHO "Memory level CRITICAL: ($FreeMem kB available) !! ${PERFDATA}"
      exitstatus=$STATE_CRITICAL ; exit $exitstatus
   fi
fi
exit $exitstatus
