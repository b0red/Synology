#!/opt/bin/bash
#
# Rensa AW's kataloger i transmission/downloads

cd /volume2/transmission

find . -name "*.txt" -exec rm -rf {} \;
find . -name "*.nfo" -exec rm -rf {} \;
