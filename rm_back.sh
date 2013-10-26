#!/bin/bash

#The path of the file to be deleted needs to be absolute path
rm_back() {
	#simple file
	if [ -f $1 ]; then
		du -k $1 > /tmp/rm_tmp
		TEMP_DU=`awk '{print $1}' /tmp/rm_tmp`
		echo $TEMP_DU
		FIVE_M=5120
		#less than 5M
		if [ $TEMP_DU -lt $FIVE_M ]; then
    			#make backup dir
			if [ ! -d ~/rm_backdir ]; then
    				mkdir ~/rm_backdir
    			fi
			#record rm log
			echo $1	>> ~/rm_back.log
			cp $1 ~/rm_backdir
		fi
	fi
	rm $1
}
rm_back $*
