function in_vim_session
	set cur_pid %self
	set next_pid (ps -o ppid:1= -p $cur_pid)
	while begin; [ (ps -o comm:1= -p $next_pid) != "vim" ]; end;
		if [ $next_pid = 1 ]
			return 1
		end
		set cur_pid $next_pid
		set next_pid (ps -o ppid:1= -p $cur_pid)
	end
	if math (count $argv)" > 0" >/dev/null
		echo $next_pid (ps -o comm:1= -p $next_pid)
	end
	return 0
end
