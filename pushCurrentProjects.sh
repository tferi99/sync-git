CURRENT_PROJECTS=.current_projects
COMMIT_MSG="auto-push by sync-git scripts"

if [ $# -eq 1 ]
then
	COMMIT_MSG=$1
	echo "CUSTOM MESSAGE: $COMMIT_MSG"
fi


commit() {
	echo "### commit ###"
	git add -A 
	git commit -am "$COMMIT_MSG" --allow-empty
	RET=$?
	if [ $RET -ne 0 ]
	then
		return 2
	fi
	COMMITTED=1
}


push() {
	echo "### push ###"
	git push
	RET=$?
	if [ $RET -ne 0 ]
	then
		return 4
	fi
	PUSHED=1
}


HERE=`pwd`

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> PUSH >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

cat $CURRENT_PROJECTS | grep -v '^[ \t]*$' | while read DIR
do
	echo "######################### $DIR #########################"
	if [ ! -d "$DIR" ]
	then
		echo "$DIR : directory not found !!!" 1>&2
	else
		cd $DIR
		commit
		if [ $? -ne 0 ]
		then
			echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! [$RET] - Error during COMMIT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"		
		else
			push
			if [ $? -ne 0 ]
			then
				echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! [$RET] - Error during PUSH !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"		
			fi
		fi
		cd $HERE
		echo
	fi
done

