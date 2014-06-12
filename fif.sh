#!/opt/bin/bash

for i in $(ls)
do
	cat $i 2> /dev/null | grep $1 > /dev/null 2>&1
    STATUS=$?
    if [ $STATUS  -eq 0 ] ; then
    	echo $i
        cat $i | grep -n $1
 	fi
done
