function to_vim
	if in_vim_session 
echo "exiting session"
exit
else
echo "not in a vim session"
end
end
