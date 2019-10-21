#!/bin/bash
#
# Check new freshdesk ticket.
# MBoth - 20/out/2019.
# Run under crontab task. Current logged user.
# subdomain, group and api key must be replaced.
# Send a sonoro and popup notification to desktop.
#
# Required: freshdesk API key, jq tool and macosx # Exec permission: chmod u+x /usr/local/bin/check_newticket.sh
# brew install jq

# Schedule suggestion. #Every minute, business time
# */1 8-20 * * * /usr/local/bin/check_newticket.sh

VOLUME=20
KEY=XXXXXXXXXXX
# chance YOURDOMAIN.
# change 9999999999999999.

#----------------------------------------------
#Request output json format.
OUT=$(curl -s -k -u "${KEY}:X" 'https://YOURDOMAIN.freshdesk.com/api/v2/search/tickets?query="group_id:99999999999999990%20AND%20status:2%20AND%20priority:>1"' | /usr/local/bin/jq)
#total parameter.
TOTAL=$(echo "${OUT}" | grep -i total | awk '{print $2}')
if [ ${TOTAL} -gt 0 ]
then
   CURR=$(osascript -e 'output volume of (get volume settings)')
   osascript -e "set volume output volume $VOLUME"
   #say take a look, new critical ticket
   say take a look
   #say critical ticket
   osascript -e 'set volume output volume $CURR'
   osascript -e 'tell application (path to frontmost application as text) to display dialog "Take a look, new critical ticket!" buttons {"OK"} with icon caution'
fi
