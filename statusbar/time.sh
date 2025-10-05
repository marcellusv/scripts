#!/usr/bin/sh
case $BUTTON in
	1) notify-send "" "$(cal --monday --week)" ;;
	3) st -e sh -c "cal --three --monday --week; read" ;;
esac

dwmdate=$(date '+%a %d-%b %H:%M %V')
printf "$dwmdate"
