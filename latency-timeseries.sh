#!/bin/bash
# This script tests latency and spits out a number (in milliseconds) every x number of seconds as passed in to us

# use the passed in site or default to google 
# use the passed in frequency or default to 1s
# use the passed in number of requests to make or default to 50
# https://stackoverflow.com/questions/16319720/bash-command-line-arguments-replacing-defaults-for-variables/16836338
SITE=${1:-"http://www.google.com"}
FREQ=${2:-"1"}
COUNT=${3:-"50"}

# header for our CSV output
HEADER="latency_ms"

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

# print the header for our CSV file
echo $HEADER

# https://ryanstutorials.net/bash-scripting-tutorial/bash-loops.php
while (sleep $FREQ && [ $COUNT -ne 0 ])
do
    # get latency
    # https://www.interserver.net/tips/kb/how-to-test-website-response-time-in-linux-terminal/
    TIME=$(curl -s -w "%{time_total}" -o /dev/null $SITE)

    # format latency into milliseconds
    # https://www.tecmint.com/bc-command-examples/
    # https://askubuntu.com/questions/179898/how-to-round-decimals-using-bc-in-bash
    TIME=$(echo "scale=0; $TIME * 1000" | bc -l | xargs printf %.0f )

    # output the raw number
    echo "${TIME}"

    # reduce count by one
    ((COUNT--))
done