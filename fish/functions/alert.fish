function alert --description 'display a message using dzen2'
	
	set arglen (count $argv)

	if begin [ $arglen != 0 ] ;and [ $argv[1] != '--help' ] ; end

		# set different time if needed
		if begin [ $arglen -ge 3 ] ; and [ $argv[1] = '-t' ] ; end
			set time $argv[2]
			set text $argv[3..$arglen]
		else
			set time 2
			set text $argv
		end

		# count lines to be displayed
		set height 80
		set lines 0
		for word in $text
			if [ $word = \n ]
				set lines (math $lines+1)
				set multilines true
			end
		end

		set yval (math "500 - ($lines * 40)")

		# different modes depending on whether there are more than one lines
		if [ $multilines ]
			echo $text | dzen2 -p $time -x 450 -y $yval -w 1020 -h $height -l $lines -fn "-*-helvetica-*-r-*-*-64-*-*-*-*-*-*-*" -e "onstart=uncollapse" ^/dev/null
		else
			echo $text | dzen2 -p $time -x 450 -y 500 -w 1020 -h $height -l $lines -fn "-*-helvetica-*-r-*-*-64-*-*-*-*-*-*-*" ^/dev/null
		end

	else
		echo "usage: alert [-t n] message-list"
	end
end
