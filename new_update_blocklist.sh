#!/opt/bin/bash

#If set to true, you will see update status for each list
#If set to false, you will just see "Start update -> End update"
VERBOSE=true

#Path configuration
folderConfigTransmission=/volume2/@appstore/transmission
folderBlockListTransmission=$folderConfigTransmission/blocklists
folderBlockListCache=$folderConfigTransmission/blocklists_update_cache
logFile=$folderConfigTransmission/update_blocklist.log
listFile=$folderConfigTransmission/list_blocklist
#echo path
updated=0

    #File & Folder checking
    if [ ! -d "$folderConfigTransmission" ]; then
      logger -t Transmission_blocklistUpdater "config folder of Transmission doesn't exist! Exiting..."
      exit 1
    fi

    if [ ! -d "$folderBlockListTransmission" ]; then
      logger -t Transmission_blocklistUpdater "blocklist folder of Transmission doesn't exist! Exiting..."
      exit 1
    fi

    if [ ! -d "$folderBlockListCache" ]; then
      logger -t Transmission_blocklistUpdater "cache folder for blocklists download doesn't exist! Creating..."
      mkdir $folderBlockListCache
    fi

    if [ ! -f "$listFile" ]; then
      logger -t Transmission_blocklistUpdater "blocklist download file doesn't exist! Exiting..."
      exit 1
    fi

    logger -t Transmission_blocklistUpdater "Updating blocklist"

    #Start to parse blocklist download file
    cat $listFile | while read line
    do
      set $(echo $line)
      listName=$(eval echo $1)
      listAuthor=$(eval echo $2)
      fileName=$(eval echo $3)
      url=$(eval echo $4)

      #Check if all variable are present in current line of the file, if not, go to the next line 
      if [ -z "$listName" ] || [ -z "$listAuthor" ] || [ -z "$fileName" ] || [ -z "$url" ]; then
       logger -t Transmission_blocklistUpdater "invalid line found in blocklist download file! Trying to continue anyway..."
       continue
      fi

      if [ $VERBOSE ]; then
         logger -t Transmission_blocklistUpdater "current list> $listName ($listAuthor)"
      fi

      finalFileExtractPath=$folderBlockListTransmission/$listName #Extract path of downloaded list
      finalFileDownloadPath=$folderBlockListCache/$fileName  #Cache path where the file is downloaded

      #Check local file size (downloaded version, ie. in the cache folder). If not exist, size = 0
      LocalSize=0
      if [ -f "$finalFileDownloadPath" ]; then
       LocalSize=`stat -qf %z $finalFileDownloadPath`
       if [ ! "$(echo $LocalSize | grep "^[ [:digit:] ]*$")" ]; then
          LocalSize=0
       fi
      fi

      #Check remote file size. If different, download and extract the new version. In the other case, go to the next line
      RemoteSize=`fetch -apsw 5 $url || continue;`
      if [ ${LocalSize:-0} -ne ${RemoteSize} ]; then
            fetch -apw 5 -o $finalFileDownloadPath $url && \
            gzip -dfkqc $finalFileDownloadPath > $finalFileExtractPath && \
            echo "[`date`] Update found and downloaded for: $listName ($listAuthor)" >> $logFile
            if [ $VERBOSE ]; then
          logger -t Transmission_blocklistUpdater "Blocklist updated"
         fi
       updated=1
      else
            echo "[`date`] No update for: $listName ($listAuthor)" >> $logFile
       
       if [ $VERBOSE ]; then
          logger -t Transmission_blocklistUpdater "No update available"
         fi
      fi
    done

    #If one or more list is updated, restart transmission
    if [ $updated -eq 0 ]; then
       logger -t Transmission_blocklistUpdater "Blocklist up to date. Nothing to do"
    else
       logger -t Transmission_blocklistUpdater "Updating finished. Restarting Transmission..."
       /etc/rc.d/transmission
    fi