DIR=`pwd`
REPORT=${DIR}/REPORT.txt

rm -f ${REPORT} 2>/dev/null

find .. -type d -name .git -exec ./_gitSync.sh {} ${REPORT} \;
