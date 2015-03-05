function enterprakt
	if [ (count $argv) = 0 ]
		pushd $epc_p
		tmux rename-window "enterprakt"
	else if [ $argv[1] = '-x' ]
		x3270 &
		if [ (count $argv) = 2 ]
			pushd {$epc_p}UB{$argv[2]}
		tmux rename-window "enterprakt"
		end
	else if [ $argv[1] = '-d' ]
		if [ (count $argv) = 2 ]
			pushd {$epc_p}UB{$argv[2]}
			tmux rename-window "enterprakt"
		else
			echo "usage: no arguments enters main directory, -x to start x3270 as well, -d x just opens directory UBx"
		end
	else
		echo "usage: no arguments enters main directory, -x to start x3270 as well, -d x just opens directory UBx"
	end
end
