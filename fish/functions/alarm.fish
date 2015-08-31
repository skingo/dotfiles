function alarm
	if echo $argv | grep -q ':'
		echo 'amixer -D pulse sset Master 100%; amixer -D pulse sset Master on; mplayer /home/skinge/Music/Orkestra\ del\ Sol/Orkestra\ del\ Sol\ -\ Party\ Party.mp3' | at $argv
	else
		sleep $argv
		amixer -D pulse sset Master 100%
		amixer -D pulse sset Master on
		mplayer /home/skinge/Music/Orkestra\ del\ Sol/Orkestra\ del\ Sol\ -\ Party\ Party.mp3 
	end
end
