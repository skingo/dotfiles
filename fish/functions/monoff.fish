function monoff
	gsettings set org.gnome.settings-daemon.plugins.power sleep-display-ac 600;
	gsettings set org.gnome.settings-daemon.plugins.power sleep-display-battery 600;
	gsettings list-recursively org.gnome.settings-daemon.plugins.power | grep 'display-';
	gsettings set org.gnome.desktop.session idle-delay 600
	gsettings list-recursively org.gnome.desktop.session | grep 'idle'
	echo "monitor dimming enabled";

end
