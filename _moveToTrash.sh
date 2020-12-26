WHAT=$1
DEST_DIR=$2

if [ ! -d "$WHAT" ]
then
	echo "$WHAT : is not a directory" >&2
	exit 1
fi

if [ ! -d "$DEST_DIR" ]
then
	echo "$DEST_DIR : is not a directory" >&2
	exit 1
fi

RND_DIR=$(uuidgen)
DEST=$DEST_DIR/$RND_DIR

echo "$WHAT"
echo "		---> $DEST"

mv $WHAT $DEST