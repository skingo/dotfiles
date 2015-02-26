function param
	if [ (count $argv) = 0 ]
       pushd $param/../
    else if [ (echo $argv | wc -c) = 2 ]
       #pushd {$param}uebung_0{$argv}
       #or pushd {$param}uebung_0{$argv}-keine_abgabe
       pushd {$param}uebung_0{$argv}*
    else
       pushd {$param}uebung_{$argv}
    end
    tmux rename-window "param"
end
