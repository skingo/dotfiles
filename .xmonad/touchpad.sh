#!/bin/bash
status=$(synclient | grep Touch | sed -E 's/^[^0-9]*//');
if [ 0 = $status ] ; then
    returnval='on';
else
    returnval='off';
fi
echo "touch $returnval"
