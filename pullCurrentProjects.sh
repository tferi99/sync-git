CURRENT_PROJECTS=.current_projects


pull() {
	echo "### pull ###"
	git pull
	RET=$?
	if [ $RET -ne 0 ]
	then
		return 3
	fi
	PULLED=1
}


HERE=`pwd`

cat $CURRENT_PROJECTS | grep -v '^[ \t]*$' | while read DIR
do
	echo "##### $DIR"
	if [ ! -d "$DIR" ]
	then
		echo "$DIR : directory not found !!!" 1>&2
	else
		cd $DIR
		pull
		if [ $? -ne 0 ]
		then
			echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! [$RET] - Error during PULL !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"		
		fi
		
		cd $HERE
		echo
	fi
done

