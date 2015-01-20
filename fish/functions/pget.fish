function pget
	ps aux | grep "$argv[1]\|CPU" | grep -v 'grep'


end
