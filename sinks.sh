#!/usr/bin/sh

add_sink() {
	if [[ $batt == "" ]]; then
		batt="-"
	fi
	
	sink_ids+=("$id")
	sink_names+=("$name")
	sink_descriptions+=("$desc")
	sink_volumes+=("$vol")
	sink_batteries+=("$batt")

	id=""
	name=""
	desc=""
	vol=""
	batt=""
}

# numb=""
# name=""
# desc=""
# volu=""
# batt=""

sink_ids=()
sink_names=()
sink_descriptions=()
sink_volumes=()
sink_batteries=()


sink_active=$(pacmd list-sinks | awk '/\*/ {getline; print $2}' | sed 's/[<>]//g')

sink_info=$(pactl list sinks | grep -e "Sink #" -e "Name:" -e "Description:" -e "^[[:space:]]Volume:" -e "bluetooth.battery")

while IFS= read -r line; do
	if [[ $line == *"Sink"* ]]; then
		# First, save the previous sink data before continueing with the next sink.
		# Note: This will trigger a reset of the single loop variables.
		if [[ $name != "" ]]; then
			add_sink
		fi

		id=("$(echo "$line" | awk -F' #' '{print $2}' )")
	elif [[ $line == *"Name"* ]]; then
		name=("$(echo "$line" | awk -F': ' '{print $2}' )")
	elif [[ $line == *"Description"* ]]; then
		desc=("$(echo "$line" | awk -F': ' '{print $2}' )")
	elif [[ $line == *"Volume"* ]]; then
		vol=("$(echo "$line" | awk '{print $5}' )")
	elif [[ $line == *"bluetooth.battery"* ]]; then
		batt=("$(echo "$line" | awk -F'= ' '{print $2}' | sed 's/"//g' )")
	fi


done <<< "$sink_info"

# Save the sink data from the final loop
add_sink



# Fetch the indices with '!'
for i in "${!sink_names[@]}"; do
	echo "${sink_ids[$i]}) ${sink_descriptions[$i]} ${sink_names[$i]} ${sink_volumes[$i]} ${sink_batteries[$i]}"
done

echo $sink_active
