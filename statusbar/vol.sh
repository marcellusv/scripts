#!/usr/bin/sh
sink=$(pactl list short | grep RUNNING | awk '{print $1}')
vol=$(pactl get-sink-volume $sink | awk '{print $5}')
echo "$vol"
