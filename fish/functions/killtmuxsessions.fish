function killtmuxsessions
	for sid in $argv;
		tmux kill-session -t $sid
	end
	if [ (count $argv) = 0 ]
		set sessions (tmux list-sessions | cut -f1 -d':' | grep -v '^1$')
		for sid in $sessions
			read confirm -p "echo \"kill session "{$sid}"? (y to confirm, decline otherwise) "\"
			if [ $confirm = 'y' ]
				tmux kill-session -t $sid
			end
		end
	end
end
