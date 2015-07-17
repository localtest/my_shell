#!/bin/bash
source /etc/profile

####
### very simple script to process image
###
### Todo
###  1. compatible with the tool mediaInfo to detect image width x height
###  2.
###  3.

####


SRC_IMG=$1
DEST_IMG=$2
WIDTH=$3
HEIGHT=$4

DEST_WIDTH=510
DEST_HEIGHT=286

BACKGROUND=""
THUMBNAIL=""
if [ $WIDTH -le $DEST_WIDTH -a $HEIGHT -le $DEST_HEIGHT ]; then
	THUMBNAIL="${DEST_WIDTH}x${DEST_HEIGHT}"
	BACKGROUND="-background black"
elif [ $WIDTH -gt $DEST_WIDTH -a $HEIGHT -gt $DEST_HEIGHT ]; then
        #if [ $WIDTH -le $HEIGHT ];then
                THUMBNAIL="${DEST_WIDTH}x${DEST_HEIGHT}^"
                BACKGROUND="-background black"
        #else
        #        THUMBNAIL="${DEST_WIDTH}x${DEST_HEIGHT}^"
        #fi
elif [ $WIDTH -gt $DEST_WIDTH ];then
        #THUMBNAIL="${DEST_WIDTH}x${HEIGHT}^"
        THUMBNAIL="${DEST_WIDTH}x${HEIGHT}"
        BACKGROUND="-background black"
elif [ $HEIGHT -gt ${DEST_HEIGHT} ];then
        THUMBNAIL="${DEST_WIDTH}x${DEST_HEIGHT}"
        BACKGROUND="-background black"
fi

gm convert $SRC_IMG -thumbnail $THUMBNAIL $BACKGROUND -gravity center -extent ${DEST_WIDTH}x${DEST_HEIGHT} $DEST_IMG
