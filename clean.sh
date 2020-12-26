# It cleans projects from build artifacts.

DEST_DIR='_TRASH'

if [ ! -d $DEST_DIR ]
then
	mkdir $DEST_DIR
fi

find .. -type d -name node_modules -exec ./_moveToTrash.sh {} $DEST_DIR \;
find .. -type d -name dist -exec ./_moveToTrash.sh {} $DEST_DIR \;
