#!/opt/bin/bash
showName="$1"
target="$2"

#Usage
function usage { echo "Usage: $0 \"show name\" \"full/path/to/show/\""; }
if [[ ! "$showName" || ! "$target" ]]; then
    echo "You must specify the show name and the target directory."
    usage
    exit
fi

#converts $1 to integer, i.e. remove trailing zeros
function toInt { echo `expr 0 + $1`; }

#extracts $2 as regex from $1
function extract { echo "$1" | grep -o -i "$2"; }

#returns the zero padded number of at least two digits
function toTwoDigits { echo $(printf "%02d" $1); }

#Gets the show id from http://services.tvrage.com/feeds/search.php?show=$showname
function getShowId {
    __showIdRegex='(?<=>)[0-9]*(?=</showid)'
    __url=$(echo "http://services.tvrage.com/feeds/search.php?show=$1")
    __showsPage=$(wget -U chrome -qO - "$__url" )
    __number=`extract "$__showsPage" "$__showIdRegex" | head -1`
    echo $__number
}

#Gets the show data from http://services.tvrage.com/feeds/episode_list.php?sid=$showid
function getShowData {
    __showDataURL=$(echo "http://services.tvrage.com/feeds/episode_list.php?sid=$1")
    __showData=$(wget -U chrome -qO - "$__showDataURL")
    echo $__showData
}

#Gets the episode title
#$1 - season
#$2 - episode
#$3 - showdata
function getEpisodeTitle {
    __regex='<Season no="'$1'">((?!<Season no).)*</Season>'
    __regey='<seasonnum>'$2'</seasonnum>((?!<episode).)*</episode>'
    __regew='<title>((?!<title).)*</title>'
    __regez='(?<=>).*(?=<)'
    __seasonContents=`echo $3 | grep -o "$__regex"`
    __episodeContents=`echo $__seasonContents | grep -o -P "$__regey"`
    __title=`echo $__episodeContents | grep -o -P "$__regew"`
    echo $__title | grep -o -P "$__regez"
}

regex=$(printf '((?<!x)[0-9]{3,4}(?!p)|[0-9]{1,2}-[0-9]{1,2}|S[0-9]{1,2}E[0-9]{1,2}|[0-9]{1,2}x[0-9]{1,2})')
fileExtensionRegex="\.[^\.]*$"

cd $target
if [[ $(pwd) != $target ]]; then
    echo "Failed to go to target directory $target"
    exit
fi

showId=`getShowId "$showName"`

if [ ! $showId ]; then
    echo "Cannot find \"$showName\" in tv-rage"
    exit
fi

echo "Downloading episode guide from tv-rage..."
showData=`getShowData $showId`
echo "Got episode guide! Now renaming files..."

#Loop over the files
for file in *
do
    seasonAndEpisode=`extract "$file" "$regex"`
    extension=`extract "$file" "$fileExtensionRegex"`
    season=`extract "$seasonAndEpisode" "((?<=^S)[0-9]{1,2}|^[0-9]{1,2}(?=[0-9]{2}$)|^[0-9]{1,2}(?=x)|[0-9]{1,2}(?=-))"`
    season=`toInt $season`
    episode=`extract "$seasonAndEpisode" '((?!^)(?<=[^0-9])[0-9]{1,3}$|(?<=[0-9])[0-9]{2}$)'`
    episode=`toInt $episode`
    episode=`toTwoDigits $episode`

    #get episode title from http://services.tvrage.com/feeds/episode_list.php?sid=$showid
    episodeTitle=`getEpisodeTitle "$season" "$episode" "$showData"`

    newfilename=`echo $showName [$season'x'$episode] - $episodeTitle$extension`

    [[ "$season" && "$episode" && "$episodeTitle" ]] && {
        echo \'"$file"\' is renamed to \'"$newfilename"\' >> tvseriesrename.log
        mv -i "$file" "$newfilename"
    }
done

echo "Done renaming files!"
