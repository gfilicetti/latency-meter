#!/bin/bash
# This script tests latency and outputs animated bars

# use the passed in site or default to google 
# use the passed in frequency or default to 1s
# https://stackoverflow.com/questions/16319720/bash-command-line-arguments-replacing-defaults-for-variables/16836338
SITE=${1:-"http://www.google.com"}
FREQ=${2:-"1"}

# time constants
GOOD=150
BAD=500

# colour constants
# https://www.shellhacks.com/bash-colors/
# https://linuxhint.com/bash_test_background_colors/
RED=$'\e[1;31m'
GREEN=$'\e[1;32m'
YELLOW=$'\e[1;33m'
RESET=$'\e[0m'

# graphics constants
DOT="#"
DASH="-"
TIP="|"

# curl format constants (pick one of these to use for the meter)
# Total time for the payload to arrive
FORMAT="%{time_total}"
# Time to start the transfer of the payload
#FORMAT="%{time_starttransfer}"
# Time for the pre-transfer
#FORMAT="%{time_pretransfer}"
# Time to make the connection
#FORMAT="%{time_connect}"
# Time to do the DNS lookup
#FORMAT="%{time_namelookup}"

# https://ryanstutorials.net/bash-scripting-tutorial/bash-loops.php
while (sleep $FREQ)
do
    # get latency
    # https://www.interserver.net/tips/kb/how-to-test-website-response-time-in-linux-terminal/
    TIME=$(curl -s -w $FORMAT -o /dev/null $SITE)

    # format latency into milliseconds
    # https://www.tecmint.com/bc-command-examples/
    # https://askubuntu.com/questions/179898/how-to-round-decimals-using-bc-in-bash
    # https://stackoverflow.com/questions/8789729/how-to-zero-pad-a-sequence-of-integers-in-bash-so-that-all-have-the-same-width
    TIME=$(echo "scale=0; $TIME * 1000" | bc -l | xargs printf %.0f | xargs printf %04d)
    PIPS=$(echo "scale=0; $TIME / 20" | bc -l | xargs printf %.0f)

    # get colour depending on time, green < 100ms, yellow > 100 < 300ms, red > 300ms
    # https://ryanstutorials.net/bash-scripting-tutorial/bash-if-statements.php
    if [ $TIME -lt $GOOD ]
    then
        STATUS=$GREEN
    elif [ $TIME -lt $BAD ]
    then
        STATUS=$YELLOW
    else
        STATUS=$RED
    fi

    # build the bar
    COUNTER=0
    while [ $COUNTER -ne 50 ]
    do
        if [ $COUNTER -gt $PIPS ]
        then
            BAR="${BAR}${DASH}"
        elif [ $COUNTER -eq $PIPS ]
        then
            BAR="${BAR}${TIP}"
        else
            BAR="${BAR}${DOT}"
        fi

        ((COUNTER++))

    done

    # finish the bar with the time in text
    BAR="${BAR} (${TIME}ms)\r"

    # output a bar
    # https://stackoverflow.com/questions/238073/how-to-add-a-progress-bar-to-a-shell-script
    echo -ne "${STATUS}${BAR}${RESET}\r"

done