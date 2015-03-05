set EDITOR vim
set -x ws $HOME/uni/ws_14-15/
set -x ss $HOME/uni/ss_14/
set fp {$ss}/func_prog/
set ids {$ss}/ids/
set epc_v {$ws}/enterprise_computing_vl/
set epc_p {$ws}/enterprise_computing_praktikum/enterprise-computing/
set info3 {$ws}/info_3-tutorium/
set leist {$ws}/leistungsbewertung/
set top {$ws}/topologie/
set param {$ws}/parametrisierte_algorithmen/parametrisierte_algorithmen/
set kompl {$ws}/komplexitaetstheorie/komplexitaetstheorie_poster/

set toprint {$HOME}/Desktop/toprint/

set krypt {$ws}/kryptologie/
set -x PYTHONSTARTUP ~/.pythonrc 
set -gx PATH {$HOME}/.cabal/bin $PATH
#set -x TERM "screen-256color-bce"


. /home/skinge/.config/fish/vi-mode.fish

# use vi mode for fish
function fish_user_key_bindings
        vi_mode_insert
end

# start tmux session (-2 is used for color support for vim solarized (though it does not seem to help))
tmux
