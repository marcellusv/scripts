#!/usr/bin/sh
case $BUTTON in
	1) notify-send "CPU usage" "$(ps axch -o cmd,%cpu --sort=-%cpu | head)" ;;
	3) st -e htop ;;
esac

load_average=$(uptime | awk -F': ' '{$0=$2}1')
printf "$load_average"

