function vimr --description 'open file in opened vim session, if such exists'
	getopts $argv | while read -l key value
		switch $key
			case s servername
				set servername $value
			case n servernumber
				set servernumber $value
			case l serverlist
				set listservers 1
			case h help
				echo "use -s <name> or --servername <name> to specify servername"
				echo "use -n <nr> or --servernumber <nr> to specify server number in server list"
				echo "use -l or --serverlist to choose server from list"
				return
			case _
				set files $files $value
		end
	end
	set available_servers (vimm --serverlist)
	set available_nrs (seq 1 (count $available_servers))
    if [ (count $available_servers) -gt 0 ]
		if [ $listservers ]
		else if begin [ $servername ]; and contains $servername $available_servers; end
			set server $servername
		else if begin [ $servernumber ]; and [ (count $available_servers) -ge $servernumber ]; end
			set server $available_servers[$servernumber]
		else
			if [ $servername ]
				echo server $servername not found
				echo using server list instead
			end
			if [ $servernumber ]
				echo servernumber $number not valid
				echo using server list instead
			end
			set listservers 1
		end
		if [ $listservers ]
			echo choose server from list
			set i 1
			for s in $available_servers
				echo "($i) $available_servers[$i]"
				set i (math $i+1)
			end
			read -p 'echo "choose number of server: "' nr
			while not contains $nr $available_nrs 
				echo option not recognized, must be one of: $available_nrs
				read -p 'echo "choose number of server: "' nr
			end
			set server $available_servers[$nr]
		else if not [ $server ]
			set server $available_servers[1]
			echo using default server $server
		end
		echo server is $server
        vimm --servername $server --remote $files
    else
		echo "no server found"
        vim $files
    end
end
