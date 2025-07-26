#!/usr/bin/sh
#mem=$(free -h | awk '/^Mem/ { print $3"/"$2 }' | sed s/i//g)
used=$(free -m | awk '/^Mem/ { print $3 }')
used_b=$(free -b | awk '/^Mem/ { print $3 }')
total_b=$(free -b | awk '/^Mem/ { print $2 }')

percent=$(echo "scale=1;100*$used_b/$total_b" | bc)

echo "$used MB($percent%)"
#printf "$used.MB ($percent%%)"
