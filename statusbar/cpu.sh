#!/usr/bin/sh
load_average=$(uptime | awk -F': ' '{$0=$2}1')
printf "$load_average"
