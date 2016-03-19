#!/bin/sh
dmenu -p "$1" -fn '12x24' -nf '#202a27' -nb '#202a27' -sf black -sb '#babdb6' <&- && echo
