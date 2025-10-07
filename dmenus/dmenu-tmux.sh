#!/bin/bash

# Fetch a list of all the available tmux sessions
sessions=$(tmux list-sessions -F "#S" 2>/dev/null)

# Fetch tmux clients tty, select the first active only
active_tty=$(tmux list-clients -F "#{client_tty}" | head -n 1)

# Prompt the user to select a session
selected=$(echo -e "[New Session]\n$sessions" | dmenu -i -c -l 30 -p "tmux sessions:")

# Option 1: User creates a new session
if [[ "$selected" == "[New Session]" ]]; then
	new_name=$(echo '' | dmenu -c -p "Enter new session name:")
	if [[ -n "$new_name" ]]; then
		tmux new-session -ds "$new_name"
		if [[ -n "$active_tty" ]]; then
			tmux switch-client -c "$active_tty" -t "$new_name"
		else
			st -e tmux attach-session -t "$new_name" &
		fi
	fi

# Option 2: User selects an existing session
elif [[ -n "$selected" ]]; then
	if [[ -n "$active_tty" ]]; then
		tmux switch-client -c "$active_tty" -t "$selected"
	else
		st -e tmux attach-session -t "$selected" &
	fi
fi
