function to_vim
	if in_vim_session 
		if not count $argv >/dev/null
			echo "exiting session"
		end
		exit
	else
		if not count $argv >/dev/null
			echo "not in a vim session"
		end
	end
end
