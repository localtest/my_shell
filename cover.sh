#!/bin/bash
source /etc/profile
set -o nounset

####
### very simple script to process image
###
### Todo
###  1. compatible with the tool mediaInfo to detect image width x height
###  2. add a option to chose delete the src image or not
###  3. compatible local src image
###  4. read from file queue to covert multi images
###  5. add the surpot of regex src file name
###  6. add some image 特效
###  7. add the support of dir
###  8. upload to qiniu storage
###  9.
###  10.
###  11.
###  12.
###  13.
###  14.
###  15.
###  16.
###  17.
###  18.
###  19.
####


##
# base config
# Todo
# 	1. add the necessary annotation here
##
SRC_IMG=$1
WIDTH=$2
HEIGHT=$3
DELETE_SRC_LOCAL_FILE=$4
DEST_WIDTH=510
DEST_HEIGHT=286

#You can special a dir to process
SRC_IMG_PATH="/tmp"

DEST_IMG_PATH="/image_demo"
if [ ! -d "$DEST_IMG_PATH" ]; then 
    mkdir "$DEST_IMG_PATH" 
fi 
LOG_PATH="./debug.log"

FILE_NAME=`basename ${SRC_IMG}`
DEST_IMG="${DEST_IMG_PATH}/${FILE_NAME}"


#Todo
# 1. check if it's the remote url
# 2. if it's the local path, it will not delete local file by default

wget -P $SRC_IMG_PATH -q $SRC_IMG
#源视频下载失败重试
for (( i=0; i<3; i++)); do
    #detect the file name
    if [ ! -f "$SRC_IMG_PATH/$FILE_NAME" ]; then 
        wget -P $SRC_IMG_PATH -q $SRC_IMG
    fi 
done
SRC_IMG="${SRC_IMG_PATH}/${FILE_NAME}"

BACKGROUND=""
THUMBNAIL=""
if [ $WIDTH -le $DEST_WIDTH -a $HEIGHT -le $DEST_HEIGHT ]; then
	THUMBNAIL="${DEST_WIDTH}x${DEST_HEIGHT}"
	BACKGROUND="-background black"
elif [ $WIDTH -gt $DEST_WIDTH -a $HEIGHT -gt $DEST_HEIGHT ]; then
        #if [ $WIDTH -le $HEIGHT ];then
                THUMBNAIL="${DEST_WIDTH}x${DEST_HEIGHT}"
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

#Delete source file
if [$DELETE_SRC_LOCAL_FILE -eq 1]
       rm -f "$SRC_IMG_PATH/$FILE_NAME"
fi

#写log
REPLACE_TIME=$(date +%Y-%m-%d_%H:%M:%S)
echo -e "$REPLACE_TIME src_img:$SRC_IMG src_width:$WIDTH src_height:$HEIGHT $THUMBNAIL $BACKGROUND" >> $LOG_PATH
