#!/usr/bin/sh

sink_active=$(pacmd list-sinks | awk '/\*/ {getline; print $2}' | sed 's/[<>]//g')

sinks_id=()
sinks_name=()
sinks_description=()
sinks_volume=()
sinks_battery=()


add_sinks() {
	# Define a placeholder for the sinks without battery indicator
	if [[ $batt == "" ]]; then
		batt="-"
	fi
	
	sinks_id+=("$id")
	sinks_name+=("$name")
	sinks_description+=("$desc")
	sinks_volume+=("$vol")
	sinks_battery+=("$batt")

	id=""
	name=""
	desc=""
	vol=""
	batt=""
}

get_sinks() {
	sink_info=$(pactl list sinks | grep -e "Sink #" -e "Name:" -e "Description:" -e "^[[:space:]]Volume:" -e "bluetooth.battery")

	while IFS= read -r line; do
		if [[ $line == *"Sink"* ]]; then
			# Logic steps:
			# 1. First sink? Skip add_sinks and start collecting data of the first sink.
			# 2. New sink? Save the previous sink data before collecting data of the next sink. Note, single loop variable (id,name,desc,vol,batt) are reset.
			if [[ $name != "" ]]; then
				add_sinks
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
	add_sinks
}

activate_sink() {
	if [[ $1 != $sink_active ]]; then
		pactl set-default-sink $1
		notify-send -h string:bgcolor:#388e3c -a pactl -t 3000 "Set default sink" "$1"
	else
		notify-send -h string:bgcolor:#ff6900 -a pactl -t 3000 "Set default sink" "Cancelled, sink already active $1"
	fi
}

select_sink() {
	get_sinks
	choices=""
	for i in "${!sinks_name[@]}"; do
		choices+="${sinks_description[$i]}|${sinks_name[$i]}\n"
	done
	choice=$(echo -e "$choices" | column -t -s "|" | dmenu -c -l 10 -i -p "Select sink:")
	activate_sink $(echo $choice | awk '{print $NF}')
}

select_sink


# echo $sink_active
