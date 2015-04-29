function send
	if [ (count $argv) -ge 1 ]
		if [ $argv[1] != '-n' ]
			set argv $argv Enter
		else
			set argv $argv[2..(count $argv)]
		end
	end
	tmux send-keys -t $argv
	
end
