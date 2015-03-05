function print
	if [ (count $argv) -le 1 ]
		echo "no printer and/or file specified"
		echo "printers include C for Sand_C111 and B for Sand_B033"
		echo "toprint in the second argument can be used to print from 'toprint' directory"
	else
		# is printer shorthand used?
		if [ $argv[1] = 'C' ]
			set printer 'Sand_C111'
		else if [ $argv[1] = 'B' ]
			set printer 'Sand_B033'
		else
			set printer $argv[1]
		end
		# print from 'toprint' folder?
		if [ $argv[2] = 'toprint' ]
			lpr -P $printer $argv[3..(count $argv)] {$toprint}*
		end
			lpr -P $printer $argv[2..(count $argv)]
	end
end

