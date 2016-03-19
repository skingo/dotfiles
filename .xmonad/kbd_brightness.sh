#!/bin/bash
# increment or decrement keyboard backlighing intensity (range 0-3)
# based on argument (inc: increment by 1, dec: decrement by 1, otherwise nothing)
val=$(cat /sys/class/leds/asus::kbd_backlight/brightness)

if [ $# -eq 1 ]
then
    if [ $* == 'inc' ]
    then
        if [ $val -lt 3 ]
        then
            val=$(($val+1))
        fi
    elif [ $* == 'dec' ]
    then
        if [ $val -gt 0 ]
        then
            val=$(($val-1))
        fi
    fi
fi
echo $val | tee /sys/class/leds/asus::kbd_backlight/brightness
