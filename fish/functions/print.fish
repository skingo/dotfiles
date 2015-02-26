function print
	if [ (count $argv) -le 1 ]
echo "no printer and/or file specified"
echo "printers include C for Sand_C111 and B for Sand_B033"
else 
if [ $argv[1] = 'C' ]
lpr -P 'Sand_C111' $argv[2]
else if [ $argv[1] = 'B' ]
lpr -P 'Sand_B033' $argv[2]
else 
lpr -P $argv[1] $argv[2]
end
end
end
