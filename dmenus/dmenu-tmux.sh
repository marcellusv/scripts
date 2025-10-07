#!/bin/bash

function open_session {
	local session_name="$1"

	# Fetch tty of all tmux clients, select the first active only
	local active_tty=$(tmux list-clients -F "#{client_tty}" | head -n 1)

	# Try to re-use an attached tmux client in the active terminal (st)
	if [[ -n "$active_tty" ]]; then
		tmux switch-client -c "$active_tty" -t "$session_name"
	else
		st -e tmux attach-session -t "$session_name" &
	fi
}

# Fetch a list of all available tmux sessions
sessions=$(tmux list-sessions -F "#S" 2>/dev/null)

# Prompt the user to select a session
selected=$(echo -e "[New Session]\n$sessions" | dmenu -i -c -l 30 -p "tmux sessions:")

# Option 1: User creates a new session
if [[ "$selected" == "[New Session]" ]]; then
	new_name=$(echo '' | dmenu -c -p "Enter new session name:")
	if [[ -n "$new_name" ]]; then
		tmux new-session -ds "$new_name"
		open_session "$new_name"
	fi

# Option 2: User selects an existing session
elif [[ -n "$selected" ]]; then
	open_session "$selected"
fi
