#!/bin/bash
source /etc/profile
#set -o nounset

####
### very simple script to process image
###
### Todo
###  2. compatible the suppot of remote(or local) video frame
###  3. compatible local src image
###  4. read from file queue to covert multi images
###  5. add the surpot of regex src file name
###  6. add some image 特效
###  7. add the support of dir
###  8. add the support to upload to cloud storage
###  9.
###  10.
###  11.
###  12.
####


#ffmpeg -i $videoSource -y -f image2 -ss 00:01:00 -vframes 1 test1.jpg
#ffmpeg -i $videoSource -y -f image2 -ss 60 -vframes 1 test1.jpg

WIDTH=
HEIGHT=
TYPE=
EFFECT=
DEST_WIDTH=
DEST_HEIGHT=
DELETE_SRC_LOCAL_FILE=0
SRC_IMG=
SRC_IMG_PATH="/tmp"
DEST_IMG_PATH="/image_demo"
if [ ! -d "$DEST_IMG_PATH" ]; then 
    mkdir "$DEST_IMG_PATH" 
fi 
LOG_PATH="./debug.log"


#
################################################################
# Usage
################################################################
#
usage() {
	echo
    printf >&1 "Usage:\n"
    printf >&1 "Convert Image: ./cover.sh <-t convert> <-e effect> <-w width> <-h height> <-d delete> <-W width> <-H width> <-f address>\n"
	echo
    printf >&1 "       -t process type.\n"
    printf >&1 "       -e special effect.\n"
    printf >&1 "       -w source image width.\n"
    printf >&1 "       -h source image height.\n"
    printf >&1 "       -d delete source file.\n"
    printf >&1 "       -W source image width.\n"
    printf >&1 "       -H source image height.\n"
    printf >&1 "       -f source image file.\n"

    echo
}
if [ -z "$1" ]; then
    usage
    exit 0
fi

while getopts "t:e:w:h:W:H:f:d" opt; do
  case $opt in
    t) TYPE="$OPTARG";;
    e) EFFECT="$OPTARG";;
    w) WIDTH="$OPTARG";;
    h) HEIGHT="$OPTARG";;
    W) DEST_WIDTH="$OPTARG";;
    H) DEST_HEIGHT="$OPTARG";;
    f) SRC_IMG="$OPTARG";;
    d) DELETE_SRC_LOCAL_FILE=1;;
    \?)    usage;
         exit 1;;
  esac
done
[ -z "$DEST_WIDTH" ] && DEST_WIDTH=500
[ -z "$DEST_HEIGHT" ] && DEST_HEIGHT=500
if [ -z "$SRC_IMG" ]; then
	usage
	exit 0
fi

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

#Todo: one detect grep twice
if [ ! $WIDTH ]; then
	WIDTH=`mediainfo $SRC_IMG | grep 'Width' | awk '{print $3}'`
fi
if [ ! $HEIGHT ]; then
	HEIGHT=`mediainfo $SRC_IMG | grep 'Height' | awk '{print $3}'`
fi


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
if [ $DELETE_SRC_LOCAL_FILE -eq 1 ]; then
       rm -f "$SRC_IMG_PATH/$FILE_NAME"
fi

#写log
REPLACE_TIME=$(date +%Y-%m-%d_%H:%M:%S)
echo -e "$REPLACE_TIME src_img:$SRC_IMG src_width:$WIDTH src_height:$HEIGHT $THUMBNAIL $BACKGROUND" >> $LOG_PATH
