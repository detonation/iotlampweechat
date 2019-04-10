#!/usr/bin/env bash
## relies on launcher.pl in weechat to pass nickname to this script
## launcher weechat_pv echo $signal_data | awk '{sub(/^[@+]/, ""); print $1}' | xargs scripts/iotlamp.sh
## launcher weechat_highlight echo $signal_data | awk '{sub(/^[@+]/, ""); print $1}' | xargs scripts/iotlamp.sh
##special thanks to david and k for helping me get this shellscript together
## TBA: rate limiting, variable duration flashing, wake field acceleration
## Update, weechat 2.2 trigger:
## trigger add iotlamp print '' '(${tg_highlight} || ${tg_tag_notify} == private) && ${buffer.notify} > 0' '' '/exec -norc -nosw scripts/iotlamp.sh "${tg_tag_nick}"'
##

LAMPIP='192.168.1.200'
RESET_COLOUR='r=255&g=255&b=255'
DEFAULT_COLOUR='r=50&g=50&b=50'
declare -A COLOUR=(
##  ['username']='r=RED&g=GREEN&b=BLUE' values 0-255)
['test']='r=252&g=7&b=223'
)
DEFAULT_CYCLE=3
declare -A CYCLE=(
##  ['username']= cycle count
)

for ((i=1, c=${CYCLE[$1]:-$DEFAULT_CYCLE}; i<=c; i++)); do
    /usr/bin/curl --silent --output /dev/null -X GET     "http://$LAMPIP/all?${COLOUR[$1]:-$DEFAULT_COLOUR}"
     sleep 0.5
    /usr/bin/curl --silent --output /dev/null -X GET     "http://$LAMPIP/all?${RESET_COLOUR}"
	[[ $i -ne $c ]] && sleep 0.5
done
