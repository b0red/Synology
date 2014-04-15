#!/opt/bin/bash
#======================================================================
# Title: blocklistgen.sh
# Description: Script for downloading and generating an IP blocklist
# Author: Ragnarok (http://crunchbang.org/forums/profile.php?id=13069)
# Date: 2013-04-13
# Version: 0.1
# Usage: $ bash blocklistgen.sh
# Dependencies: bash, coreutils, gzip, wget
# Updated by NotJohn to allow download of ip list in DAT format for uTorrent
#======================================================================

# Save path for the blocklist
blocklist="/volume2/@appstore/transmission/blocklists/ipfilter.dat"
uTorrentBlockList="/volume2/@appstore/transmission/blocklists/ipfilter.dat"
# Directory for storing temporary lists
# tmpfldr="/volume1/@appstore/uTorrent/utorrent-server-v3_0/scripts/tmp"
tmpfldr="/volume2/@appstore/transmission/tmp"

# Path to TransmissionMail.sh
source /volume1/my_scripts/email_variables.sh
#MAILPATH=/volume1/my_scripts/TransmissionMail.sh
SUBJECT="Transmission!"
HEADER="Transmission..."
INFO_1="Stopping the Transmission Daemon!"
INFO_2="New blocklists downloaded and merged!"
INFO_3="Transmission Daemon started!"

# Beautify the blocklist after it is generated
beautify=true

# Disabled. This doesn't work as expected for some reason
#check_for_paths() {
#  if [[ ! -d "$tmpfldr" ]] && [[ ! -r "$tmpfldr" ]] && [[ ! -w "$tmpfldr" ]]; then
#    echo -e "Please make sure " "$tmpfldr" " exists and you have read/write access\nExiting"
#    exit 1
#  fi
#}

# http://wiki.bash-hackers.org/scripting/style
check_for_depends() {
  my_needed_commands="cat gunzip mv rm sed sort wget"

  missing_counter=0
  for needed_command in $my_needed_commands; do
    if ! hash "$needed_command" >/dev/null 2>&1; then
      printf "Command not found in PATH: %s\n" "$needed_command" >&2
      ((missing_counter++))
    fi
  done

  if ((missing_counter > 0)); then
    printf "Minimum %d commands are missing in PATH, aborting\n" "$missing_counter" >&2
    exit 1
  fi
}

backup_blocklist() {
  # Check for and backup blocklist
  echo "Checking for blocklist..."
  if [[ -f "$blocklist" ]]; then
    echo "Backing up blocklist and overwriting old backup if exists..."
    mv -f $blocklist ${blocklist}.old
  fi
}

# Stopping Transmission and echo to nail
sh /var/packages/transmission/scripts/start-stop-status stop
echo $INFO_1 | /opt/bin/nail -s "$INFO_1" $EMAIL_P

downloads_lists() {
  # Download blocklists
  # This is where you add/remove blocklists
  # Downloaded lists must follow the following naming format: bl-[zero or more characters].gz
	# https://www.iblocklist.com/list.php?list=bt_level1  
echo "Downloading lists..."
  wget -q "http://list.iblocklist.com/?list=bcoepfyewziejvcqyhqo&fileformat=dat&archiveformat=gz" -O $tmpfldr/bl-iana-reserved.gz
  wget -q "http://list.iblocklist.com/?list=bt_ads&fileformat=dat&archiveformat=gz" -O $tmpfldr/bl-ads.gz
  wget -q "http://list.iblocklist.com/?list=bt_bogon&fileformat=dat&archiveformat=gz" -O $tmpfldr/bl-bogon.gz
  wget -q "http://list.iblocklist.com/?list=bt_dshield&fileformat=dat&archiveformat=gz" -O $tmpfldr/bl-dshield.gz
  wget -q "http://list.iblocklist.com/?list=bt_hijacked&fileformat=dat&archiveformat=gz" -O $tmpfldr/bl-hijacked.gz
  wget -q "http://list.iblocklist.com/?list=bt_level1&fileformat=p2p&archiveformat=gz" -O $tmpfldr/bl-level1.dat
  wget -q "http://list.iblocklist.com/?list=bt_level2&fileformat=dat&archiveformat=gz" -O $tmpfldr/bl-level2.gz
  wget -q "http://list.iblocklist.com/?list=bt_level3&fileformat=dat&archiveformat=gz" -O $tmpfldr/bl-level3.gz
  wget -q "http://list.iblocklist.com/?list=bt_microsoft&fileformat=dat&archiveformat=gz" -O $tmpfldr/bl-microsoft.gz
  wget -q "http://list.iblocklist.com/?list=bt_spyware&fileformat=dat&archiveformat=gz" -O $tmpfldr/bl-spyware.gz
  wget -q "http://list.iblocklist.com/?list=bt_templist&fileformat=dat&archiveformat=gz" -O $tmpfldr/bl-badpeers.gz
  wget -q "http://list.iblocklist.com/?list=ijfqtofzixtwayqovmxn&fileformat=dat&archiveformat=gz" -O $tmpfldr/bl-primary-threats.gz
  wget -q "http://list.iblocklist.com/?list=pwqnlynprfgtjbgqoizj&fileformat=dat&archiveformat=gz" -O $tmpfldr/bl-iana-multicast.gz
  echo "Download complete"
}

merge_lists() {
  # Merge blocklists
  echo "Merging lists..."
  cat ${tmpfldr}/bl-*.gz > ${blocklist}.gz
}

decompress_blocklist() {
  # Decompress the gzip archive
  if [[ -f "${blocklist}.gz" ]]; then
    echo "Decompressing..."
    gunzip ${blocklist}.gz
    echo "Blocklist successfully generated"
  else
    echo -e "Unable to find ${blocklist}.gz\nExiting"
    remove_temp
    exit 1
  fi
}

beautify_blocklist () {
  # Cleanup the blocklist
  # This will remove comments, empty lines and sort the list alphabetically
  if $beautify; then
    echo -e "Beautification started\nRemoving comments and blank lines..."
    sed -i -e '/^\#/d' -e '/^$/d' $blocklist
    echo "Sorting alphabetically..."
    sort $blocklist > ${tmpfldr}/blocklist.p2p.tmp && mv -f ${tmpfldr}/blocklist.p2p.tmp $blocklist
    echo "Beautification complete"
  fi
}

# Info on blocklists to nail
# echo $INFO_2 | /opt/bin/nail -s "$INFO_2" $EMAIL_P

remove_temp() {
  # Remove temporary blocklists
  echo "Removing temporary files..."
  rm -f ${tmpfldr}/bl-*.gz
}


update_utorrent() {
   #Replace uTorrent Block List
   cp -f $blocklist $uTorrentBlockList

   #restart uTorrent
   echo -e "Restarting Transmission"
   sh /var/packages/transmission/scripts/start-stop-status restart
   echo -e "Restart Complete"
}

check_for_depends
#check_for_paths
backup_blocklist
downloads_lists
merge_lists
decompress_blocklist
remove_temp
beautify_blocklist
update_utorrent

# Restarting TTransmission and echo to nail
sh /var/packages/transmission/scripts/start-stop-status restart
echo $INFO_3 | /opt/bin/nail -s "$INFO_3" $EMAIL_P


echo "Done!"

exit 0
