#!/bin/bash
FILE_LOG=/tmp/log/decrypt.log
FILE_WDP_INPUT=/tmp/infile/
FILE_WDP_OUTPUT=/tmp/outfile/
FILE_WDP_BACKUP=/tmp/backup/
FILE_KEY=/tmp/key/key.secret
FILE_TYPE=*.gpg

#echo "$(date)" >> $FILE_LOG
#echo "  Start connect to SFTP" >> $FILE_LOG
#sftp wdpuser@sftp.wpeg.bbl <<-EOF
#cd Out
#lcd /tmp/infile/
#get *.gpg
#rm *.gpg
#exit
#EOF

echo "  Start decrypt file" >> $FILE_LOG
count=0	
for FILE in $FILE_WDP_INPUT$FILE_TYPE
do
	if [ -f "$FILE" ]; then
		FILE_NAME_ENCRYPT="$(basename $FILE)"
		FILE_NAME_OUT="$(basename -s .gpg $FILE)"
		gpg --batch --yes -o $FILE_WDP_OUTPUT$FILE_NAME_OUT --passphrase-file $FILE_KEY $FILE
		retval=$?
		if [ $retval -eq 0 ]; then			
			count=`expr $count + 1`	
			echo "  $FILE is decrypted" >> $FILE_LOG
		else
			echo "  **Error code $? $FILE is not decrypted" >> $FILE_LOG
		fi
	else
		echo "  FILE does not exist." >> $FILE_LOG
	fi	
done

if [ -f "$FILE" ]; then
	echo "  Start Backup file" >> $FILE_LOG
	mv $FILE_WDP_INPUT$FILE_TYPE $FILE_WDP_BACKUP >> $FILE_LOG
fi

echo "  $count file(s) decrypted." >> $FILE_LOG
echo "$(date)" >> $FILE_LOG
echo "-------------------------------Finish-------------------------------" >> $FILE_LOG