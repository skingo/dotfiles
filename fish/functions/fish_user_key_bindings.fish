
#vi_mode_insert
fish_vi_mode
bind -M insert \cg end-of-line
bind -M insert \ce end-of-line
bind -M insert \cx beginning-of-line
bind -M insert \ca beginning-of-line
bind -M insert \cy yank
bind -e -M insert \cd
bind -e \cd
fzf_key_bindings
