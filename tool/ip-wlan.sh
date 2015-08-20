#!/bin/bash
# auto get ip in lan

signal_exit()
{
        echo "Ctrl + c.\n"
        exit 0
}

trap "signal_exit" TERM INT HUP


network_card_name=$(cat /proc/net/dev | grep -v 'lo' | awk '{if($2>0 && NR > 2) print substr($1, 0, index($1, ":") - 1)}')

network=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/' | cut -f1,2,3 -d .)
if [[ "$?" -ne 0 ]];then
    echo "Not found network, get ip failure..." 
    exit 1
fi

for i in $(seq 1 254)
do
    ip="$network.$i"
    ping -c 1 -i 1 $ip >/dev/null 2>&1
    if [[ "$?" -ne 0 ]]; then
        echo " " $ip " ...ok"
    fi
done

