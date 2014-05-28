#!/opt/bin/bash
NEW="\\\b"
DPATH="/opt/share/nano/*.nanorc"
BPATH="/opt/share/nano/"
[ ! -d $BPATH ] && mkdir -p $BPATH || :
for f in $DPATH
do
  if [ -f $f -a -r $f ]; then
  	/bin/cp $f "$f.bak"
    sed -i "s/\\\</$NEW/g" "$f"
    sed -i "s/\\\>/$NEW/g" "$f"
   else
    echo "Error: Cannot read $f"
  fi
done
