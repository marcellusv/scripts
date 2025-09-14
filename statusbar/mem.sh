#!/usr/bin/sh
case $BUTTON in
	1) notify-send "RAM usage" "$(ps axch -o cmd,%mem --sort=-%mem | head)" ;;
	3) st -e htop ;;
esac

used=$(free -m | awk '/^Mem/ { print $3 }')
used_b=$(free -b | awk '/^Mem/ { print $3 }')
total_b=$(free -b | awk '/^Mem/ { print $2 }')
percent=$(echo "scale=1;100*$used_b/$total_b" | bc)
echo "$used MB($percent%)"
