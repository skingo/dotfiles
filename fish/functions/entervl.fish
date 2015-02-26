function entervl
	pushd $epc_v
    if [ (count $argv) != 0 ]
        open 0{$argv}*.pdf
    end 
    tmux rename-window "entervl"
end
