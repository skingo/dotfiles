function phonemount
	set usbinfo (lsusb | grep HTC)
	set bus (lsusb | cut -d' ' -f 2)
	set device (lsusb | cut -d' ' -f 4 | tr -d :)
	gvfs-mount $argv mtp://[usb:{$bus},{$device}]/
	#echo mtp://[usb:{$bus},{$device}]/ | gvfs-mount
	echo use phonemount -u to unmount
end
