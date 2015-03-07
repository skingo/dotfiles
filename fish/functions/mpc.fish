function mpc
	if [ (count $argv) = 1 ]
		pushd {$mpc}/assignment_{$argv}
	else
		pushd $mpc
	end
end
