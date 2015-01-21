function info
	if [ (count $argv) = 0 ]
       pushd $info3
    else if [ (echo $argv | wc -c) = 2 ]
       pushd {$info3}uebung_0{$argv}
    else
       pushd {$info3}uebung_{$argv}
    end
    tmux rename-window "info 3"
end
