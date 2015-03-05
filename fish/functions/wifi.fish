function wifi
	if [ (count $argv) = 0 ]
		/usr/bin/nm-connection-editor 
	else if [ $argv = '-c' ]
		/usr/bin/nm-connection-editor 
	else if [ $argv = '-a' ]
		/usr/bin/nm-applet 
	else
		echo "usage: -c for connection editor, -a for tray applet"
	end
end
