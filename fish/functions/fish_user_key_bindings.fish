function fish_user_key_bindings
	## old hackish vi-mode
	#vi_mode_insert
	## vi-mode provided by fish (deprecated)
	#fish_vi_mode
	## new vi-mode provided by fish, commented out due to omf key bindings
	#fish_vi_key_bindings
	bind -M insert \cg end-of-line
	bind -M insert \ce end-of-line
	bind -M insert \cx beginning-of-line
	bind -M insert \ca beginning-of-line
	bind -M insert \cy yank
	bind -e -M insert \cd
	bind -e \cd
	fzf_key_bindings
end
