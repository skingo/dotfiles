#!/bin/sh

bluez-test-audio disconnect 00:0D:44:31:B4:DF
pacmd set-card-profile 0 output:analog-stereo+input:analog-stereo
sleep 3
rfkill block bluetooth 
