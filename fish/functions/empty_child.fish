function empty_child
	env HOME=/tmp/foo fish -c "set HOME /home/skinge; "$argv
end
