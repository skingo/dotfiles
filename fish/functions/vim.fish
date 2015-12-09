function vim --description 'start vim with a server name to avoid server name duplication'
	
		#set server_name "MAIN"
	#end

	set curdir (pwd)
	set curdir (echo $curdir | sed -E 's/./\U&/g' | sed -E 's/ /_/g')
	set curdir (echo $curdir | sed -E 's,(.)/,\1\n,g')
	set locdir $curdir[-1]

	#set used_names (ps ax | grep vim | grep 'servername' | sed -E 's/^.*servername (\w*)( .*|$)/\1/g')
	set used_names (command vim --serverlist)

	# find unused server name by repeatedly adding one level of path name
	set name_used "used"
	for i in (seq -2 -1 -(count $curdir))
		set name_used ""
		for i in $used_names
			if [ $i = $locdir ]
				set name_used "used"
				break
			end
		end
		if [ -z $name_used ]
			break
		end
		set locdir $curdir[$i]__$locdir
	end

	if [ -z $name_used ]
		set server_name $locdir
	else
		set server_name "MAIN"
		set num 1
		while [ -n $name_used ]
			set server_name_candidate $server_name$num
			set name_used ""
			for i in $used_names
				if [ $server_name_candidate = $i ]
					set name_used "used"
					break
				else
					continue
				end
			end
			set num (math "$num+1")
		end
		set server_name $server_name_candidate
	end

	if [ -z $server_name ]
        echo 'not a tex file or no non-extension part, no server to create'
		command vim $argv
	else
        # run in server mode
        # now we need to make sure the forward search connects to the right server
        # check in .vimrc or tex.vim to see if it is correct
        echo "creating server called $server_name"
        command vim --servername $server_name -c "echohl MoreMsg | echomsg \"Server name: $server_name\" | echohl None" $argv
	end
end
