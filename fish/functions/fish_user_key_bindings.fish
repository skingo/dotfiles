function fish_user_key_bindings
	#vi_mode_insert
	#fish_vi_mode
	fish_vi_key_bindings
	bind -M insert \cg end-of-line
	bind -M insert \ce end-of-line
	bind -M insert \cx beginning-of-line
	bind -M insert \ca beginning-of-line
	bind -M insert \cy yank
	bind -e -M insert \cd
	bind -e \cd
	fzf_key_bindings
end
