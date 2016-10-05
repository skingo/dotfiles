set -x EDITOR vim
set uni /home/skinge/uni
set -x ws {$uni}/ws_14-15
set -x ss {$uni}/ss_15
set epc_v {$ws}/enterprise_computing_vl/
set epc_p {$ws}/enterprise_computing_praktikum/enterprise-computing/
set info3 {$ws}/info_3-tutorium/
set leist {$ws}/leistungsbewertung/
set top {$ws}/topologie/
set param {$ws}/parametrisierte_algorithmen/parametrisierte_algorithmen/
set kompl {$ws}/komplexitaetstheorie/komplexitaetstheorie_poster/
set mpc {$ss}/massively_parallel_computing/
set algeo {$ss}/algebraische_geometrie/

set toprint {$HOME}/Desktop/toprint/

set krypt {$ws}/kryptologie/
set -x PYTHONSTARTUP ~/.pythonrc
set -gx PATH {$HOME}/.cabal/bin {$HOME}/.local/bin $PATH
#set -x TERM "screen-256color-bce"
# avoid problems with java stuff in xmonad
set -gx _JAVA_AWT_WM_NONREPARENTING 1
set -gx AWT_TOOLKIT MToolkit

# get xdg-open working again
set -x GNOME_DESKTOP_SESSION_ID 42

# use dmenu to ask for sudo password (use sudo -A cmd)
set -x SUDO_ASKPASS /home/skinge/.xmonad/dpass.sh

# fzf setup
# make fzf work
#set TMPDIR /home/skinge/tmp
# additional options for alt+c command
set -x FZF_ALT_C_OPTS "--preview 'ls {}'"
#set -x FZF_ALT_C_OPTS "--bind \"ctrl-o:execute(.; echo pushd {})\""
#set -x FZF_ALT_C_OPTS $FZF_ALT_C_OPTS "--bind \"ctrl-o:execute(echo {})\""
#set -x FZF_ALT_C_OPTS $FZF_ALT_C_OPTS "--bind 'ctrl-o:execute(ls . | less)'"

# colorize man and less pager
set -x LESS_TERMCAP_mb \e\[01\x3b31m; 
set -x LESS_TERMCAP_md \e\[01\x3b38\x3b5\x3b74m; 
set -x LESS_TERMCAP_me \e\[0m; 
set -x LESS_TERMCAP_se \e\[0m; 
set -x LESS_TERMCAP_so \e\[38\x3b5\x3b46\x3b01m; 
# set -x LESS_TERMCAP_so \e\[01\x3b33\x3b02\x3b47m
set -x LESS_TERMCAP_ue \e\[0m; 
set -x LESS_TERMCAP_us \e\[04\x3b38\x3b5\x3b146m 

#fish_vi_mode
fish_vi_key_bindings
#. /home/skinge/.config/fish/vi-mode.fish

# set additional colors for ls
set -gx LS_COLORS (dircolors /home/skinge/.dir_colors | grep -v 'export' | cut -d"'" -f2)

# use vi mode for fish
#function fish_user_key_bindings
        #vi_mode_insert
#end

# start tmux session (-2 is used for color support for vim solarized (though it does not seem to help))
#tmux
# opens tmux and creates session 1 if it does not exists, else it copies session 1
if set -q TMUX;
else;
	if begin; tmux has-session -t 1; end; tmux new-session -t 1; else; tmux new-session -s 1; end
end;
