function fncts
	ls $HOME/.config/fish/functions/ | sed 's/\(.*\)\..*/\1/' | less

end
