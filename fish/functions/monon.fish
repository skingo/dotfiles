function monon
	gsettings set org.gnome.settings-daemon.plugins.power sleep-display-ac 0;
	gsettings set org.gnome.settings-daemon.plugins.power sleep-display-battery 0;
	gsettings list-recursively org.gnome.settings-daemon.plugins.power | grep 'display-';
	gsettings set org.gnome.desktop.session idle-delay 0
	gsettings list-recursively org.gnome.desktop.session | grep 'idle'
	echo "monitor dimming disabled";

end
