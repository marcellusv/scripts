#!/usr/bin/sh

sink_names=()
sink_descriptions=()
sink_volumes=()
sink_battery=()

sink_info=$(pactl list sinks | grep -e "Name:" -e "Description:" -e "^[[:space:]]Volume:")

while IFS= read -r line; do
	if [[ $line == *"Name"* ]]; then
		sink_names+=("$(echo "$line" | awk -F': ' '{print $2}' )")
	elif [[ $line == *"Description"* ]]; then
		sink_descriptions+=("$(echo "$line" | awk -F': ' '{print $2}' )")
	elif [[ $line == *"Volume"* ]]; then
		sink_volumes+=("$(echo "$line" | awk '{print $5}' )")
	fi

done <<< "$sink_info"


echo "_______Sink Names:"
# Fetch the indices with '!'
for i in "${!sink_names[@]}"; do
	echo "$i) ${sink_descriptions[$i]} ${sink_names[$i]} ${sink_volumes[$i]} ${sink_battery[$i]}"
done
