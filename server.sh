#!/bin/bash

config_file="server_config.cfg"
server_fifo=$(cat "$config_file")

if read request < $server_fifo; then
	echo "Serverul a primit cererea: $request"
	pid=$(echo "$request" | grep -oP '(?<=\[)\d+' )
	command_name=$(echo "$request" | grep -oP '(?<=: ).*(?=\])' )

	client_fifo="/home/mara/server-client-$pid"
	if [[ ! -p $client_fifo ]]; then
		mkfifo $client_fifo
	fi
	
	man_output=$(man "$command_name" 2>/dev/null || echo "Eroare: Nu exista pagina de manual pentru $command_name")
	echo "$man_output" > $client_fifo
	echo "Raspuns trimis clientului $pid in FIFO-ul $client_fifo"
fi

