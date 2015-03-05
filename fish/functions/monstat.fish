function monstat
	echo "monitor dimming times:";
	gsettings list-recursively org.gnome.settings-daemon.plugins.power | grep 'display-';
	gsettings list-recursively org.gnome.desktop.session | grep 'idle'

end
