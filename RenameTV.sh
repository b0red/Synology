#!/opt/bin/bash
#!/bin/bash
ext=$1
if [ ! $ext ]; then
  ext="avi"
fi
FILES=`find . -iname "*.$ext" -printf "%p\n"`
IFS="
"
for i in $FILES; do
	dirname=`dirname $i`
  	g=`echo $i|perl -e '<STDIN> =~ m/S\d?(\d)E(\d+)/i; $1 and  print $1 . "x" . $2'`

	if [ ! $g ]; then
    	g=`echo $i|perl -e '<STDIN> =~ m/(\d)x(\d\d)/i; $1 and  print $1 . "x" . $2'`
    fi
    if [ ! $g ]; then
    	g=`echo $i|perl -e '<STDIN> =~ m/(\d)(\d\d)/i; $1 and print $1 . "x" . $2;'`
    fi
    if [ ! $g ]; then
    	g=`echo $i|perl -e '<STDIN> =~ m/(\d\d)/i; $1 and print "1x" . $1'`
    fi

	if [ $g ]; then
    	g="$dirname/$g.$ext"
        if [[ "$g" != "$i" ]]; then
        	echo "if [ ! -e \"$g\" ]; then mv  \"$i\" \"$g\"; fi"
        fi
    fi
done
