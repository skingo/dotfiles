#!/bin/sh

rfkill unblock bluetooth
sleep 2
bluez-test-audio connect 00:0D:44:31:B4:DF
pacmd set-card-profile 0 off

card_index=$(pacmd list-cards | grep -B 1 bluez_card | head -n 1 | cut -d' ' -f 6)
pacmd set-card-profile $card_index hsp
