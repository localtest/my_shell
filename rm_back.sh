#!/bin/bash

#The path of the file to be deleted needs to be absolute path
rm_back() {
	#simple file
#if [ -f $1 ]; then
		sourcefile=$1
		if [ ${sourcefile:0:1} != "/" ]; then
			filename=`pwd $1`
			filename=${filename}"/"$1
		else
			filename=$sourcefile
		fi
		du -sk $filename > /tmp/rm_tmp
		FILE_CAPACITY=`awk '{print $1}' /tmp/rm_tmp`
		echo "The capacity of the file you removed is "$FILE_CAPACITY"k!"

		#less than 99M
		MAX_CAPACITY=101376
		if [ $FILE_CAPACITY -lt $MAX_CAPACITY ]; then
   			#check and make backup dir
			if [ ! -d ~/rm_backdir ]; then
   				mkdir ~/rm_backdir
			else 
				rm -fr ~/rm_backdir/*
   			fi
			#record rm log
			echo $filename	> ~/rm_back.log
			cp -R $filename ~/rm_backdir/
		fi
#fi
rm -fr $1
}
rm_back $*
