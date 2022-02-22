GIT_DIR=$1
REPORT=$2

if [ ! -d "$GIT_DIR" ]
then
	echo "$GIT_DIR : not a Git directory"
	exit 1
fi

echo ${GIT_DIR} | grep -q '_IGNORE'
if [ $? -eq 0 ]
then
	exit 0
fi	

cd $GIT_DIR

cd ..
DIR=`pwd`

PULLED=0
COMMITTED=0
PUSHED=0

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

echo "=============== Git sync of ($DIR)... ========================="

pull
if [ $? -ne 0 ]
then
	# try first commit
	commit
	
	# and pull again
	pull
	if [ $? -ne 0 ]
	then
		echo "PULL error in: $DIR" >> $REPORT
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! [$RET] - Error during PULL !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		exit 10
	fi
fi

# if not comitted yet
if [ $COMMITTED -eq 0 ]
then
	commit
	if [ $? -ne 0 ]
	then
		echo "COMMIT error in: $DIR" >> $REPORT
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! [$RET] - Error during COMMIT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		exit 11
	fi
fi

push
if [ $? -ne 0 ]
then
	echo "PUSH error in: $DIR" >> $REPORT
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! [$RET] - Error during PUSH !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	exit 12
fi

echo "OK - $DIR" >> $REPORT
