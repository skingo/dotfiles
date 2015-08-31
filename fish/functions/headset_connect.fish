function headset_connect
	rfkill unblock bluetooth 
	sleep 2
	bluez-test-audio connect 00:0D:44:31:B4:DF
	pacmd set-card-profile 0 off
end
