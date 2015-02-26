function twotwoprint
	if [ (count $argv) -le 1 ]
        echo "Usage: twotwoprint <printer name> <file(s)>"
        echo "Possible printers at university are Sand_C111, Sand_B033 and Morgenstelle_N03"
    else
        lpr -P $argv[1] -o number-up=2 -o sides=two-sided-long-edge $argv[2..-1]
    end
end
