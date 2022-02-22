CURRENT_PROJECTS=.current_projects


commit() {
	echo "### commit ###"
	git add -A 
	git commit -am "auto push" --allow-empty
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

cat $CURRENT_PROJECTS | grep -v '^[ \t]*$' | while read DIR
do
	echo "##### $DIR"
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

