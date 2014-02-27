#!/opt/bin/bash
[ -f /baton ] || touch /baton
find . -newer /baton -exec cp {} /mynewhome \;
if [ $? -eq 0 ]; then
  touch /baton
else
  echo "ERROR!"
fi
