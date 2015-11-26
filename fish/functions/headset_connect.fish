function headset_connect
	rfkill unblock bluetooth 
	sleep 2
	bluez-test-audio connect 00:0D:44:31:B4:DF; or rfkill block bluetooth
	pacmd set-card-profile 0 off

	set card_index (pacmd list-cards | grep -B 1 bluez_card | head -n 1 | cut -d' ' -f 6)
	echo "card as number $card_index"
	if [ (count $argv) != 0 ]
		echo "profile set to hsp"
		pacmd set-card-profile $card_index hsp
	else
		echo "profile set to a2dp"
		if [ (count (pgrep -f Blather.py)) != 0 ]
			pkill -f Blather.py
			echo "blather was stopped"
		end
		pacmd set-card-profile $card_index a2dp
	end
end
