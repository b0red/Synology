#!/opt/bin/bash

export dir=''; export prefix='  ';
find /volume2/Disk2 -type f \( -iname "*.avi" -o -iname "*.m*v" -o -iname "*.iso" -o -iname "*.mp*" \) |

while read file; do \
  if [ ! "$dir" == "$(dirname $file)" ]; then \
    export dir="$(dirname $file)";
    slashes=$(echo "$dir" | sed 's#[^/]##g' | wc -c);
    export prefix='';
    for (( i=1; i<$slashes; i++ )); do \
      export prefix="$prefix  ";
    done;
    echo "$prefix$dir/";
    export prefix="$prefix  ";
  fi;
  echo "$prefix$(basename $file)";
done
