if [ "$#" -lt 1 ]
then
	URL="http://www.tagesanzeiger.ch/kultur/kino/Hollywoods-Hofnaerrin/story/30040946"
else
	URL=$1
fi

TEMPFILE="source.html"
URLTMPFILE="urls.tmp"
URLFILE="urls.txt"

WGET=$(which wget)

CMD="$WGET -O \"$TEMPFILE\" \"$URL\""
echo "Executing command '$CMD'"

eval "$CMD"
echo ""

PATTERN="(podcast\.newsnetz\.tv\/podcast\/get_file.php\?file=[0-9]+.mp4)"

CMD="grep --only-matching --extended-regexp \"$PATTERN\" \"$TEMPFILE\" >> \"$URLTMPFILE\""
echo "Executing command '$CMD'"

eval "$CMD"
echo ""

LINESNEW=$(wc -l "$URLTMPFILE" | awk '{print $1}')
LINES=$((LINESNEW-LINESPREV))
echo "A total of $LINES links found for pattern"
LINESPREV=$LINESNEW

echo ""

CMD="cat \"$URLTMPFILE\" | sort | uniq > \"$URLFILE\""
echo "Executing command '$CMD'"

eval "$CMD"
echo ""

LINESNEW=$(wc -l "$URLFILE" | awk '{print $1}')
echo "Downloading a total of $LINESNEW assets"
echo ""

CMD="$WGET -i \"$URLFILE\""
echo "Executing command '$CMD'"

eval "$CMD"
echo ""

echo "Done."
echo ""