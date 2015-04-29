function print
	if [ (count $argv) = 0 ]
		echo "no printer and/or file specified"
		echo "printers include C for Sand_C111, B for Sand_B033 and M for Morgenstelle_N03"
		echo "toprint in the second argument can be used to print from 'toprint' directory"
	else
		# is printer shorthand used?
		if [ $argv[1] = 'C' ]
			set printer 'Sand_C111'
		else if [ $argv[1] = 'B' ]
			set printer 'Sand_B033'
		else if [ $argv[1] = 'M' ]
			set printer 'Morgenstelle_N03'
		else if [ $argv[1] = 'int' ]
			read -p  "echo 'enter printer '" printer
			if [ (count $argv) = 1 ]
				read -p "echo 'enter files and options '" input
				set argv $argv $input
			end
		else
			set printer $argv[1]
		end
		# print from 'toprint' folder?
		if [ $argv[2] = 'toprint' ]
			if [ (count $argv) -ge 3 ]
				set args argv[3..(count $argv)]
			end
			lpr -P $printer $args {$toprint}*
		end
			lpr -P $printer $argv[2..(count $argv)]
	end
end
