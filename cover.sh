#!/bin/bash
source /etc/profile
#set -o nounset

####
### very simple script to process image
###
### Todo
###  1. read from file queue to covert multi images
###  2. add the surpot of regex src file name
###  3. add the support of dir
###  4. add the support to upload to cloud storage
###  5.
####

WIDTH=
HEIGHT=
TYPE=
EFFECT=
DEST_WIDTH=
DEST_HEIGHT=
TARGET=
DELETE_SRC_LOCAL_FILE=0
SRC_IMG=
OFFSET=0
LEVEL=0
COLOR=
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
    printf >&1 "Convert Image: ./cover.sh <-t convert> <-e effect> <-w width> <-h height> <-d delete> <-W width> <-H width> <-o offset> <-m target name> <-l level> <-c color> <-f address>\n"
	echo
    printf >&1 "       -t process type.\n"
    printf >&1 "       -e special effect.\n"
    printf >&1 "       -w source image width.\n"
    printf >&1 "       -h source image height.\n"
    printf >&1 "       -d delete source file.\n"
    printf >&1 "       -W source image width.\n"
    printf >&1 "       -H source image height.\n"
    printf >&1 "       -o offset.\n"
    printf >&1 "       -m target name.\n"
    printf >&1 "       -l process level.\n"
    printf >&1 "       -c process color.\n"
    printf >&1 "       -f source image file.\n"

    echo
}
if [ -z "$1" ]; then
    usage
    exit 0
fi

while getopts "t:e:w:h:W:H:o:m:l:c:f:d" opt; do
  case $opt in
    t) TYPE="$OPTARG";;
    e) EFFECT="$OPTARG";;
    w) WIDTH="$OPTARG";;
    h) HEIGHT="$OPTARG";;
    W) DEST_WIDTH="$OPTARG";;
    H) DEST_HEIGHT="$OPTARG";;
    o) OFFSET="$OPTARG";;
    m) TARGET="$OPTARG";;
    l) LEVEL="$OPTARG";;
    c) COLOR="$OPTARG";;
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

####################
### Download Remote File
####################
download() {
	local src_img=$1
	local file_name=$2
	local retry_times=3

	SRC_IMG="${SRC_IMG_PATH}/${file_name}"

	local protocol=${src_img:0:8}
	if [ $protocol != "http://" -a $protocol != "https://" ]; then
		return
	fi 
	for (( i=0; i<$retry_times; i++)); do
		if [ ! -f "$SRC_IMG_PATH/$file_name" ]; then 
			wget -P $SRC_IMG_PATH -q $src_img -O $SRC_IMG
		fi 
	done
}
#Todo: One Detect Grep Twice
detect_width_height() {
	local src_img=$1
	if [ ! $WIDTH ]; then
		WIDTH=`mediainfo $src_img | grep 'Width' | awk '{print $3}'`
	fi
	if [ ! $HEIGHT ]; then
		HEIGHT=`mediainfo $src_img | grep 'Height' | awk '{print $3}'`
	fi
}

FILE_NAME=`basename ${SRC_IMG}`
if [ "$TARGET" != "" ]; then
	FILE_NAME=$TARGET
fi
if [ "$TYPE" != "snapshot" ]; then
	download $SRC_IMG $FILE_NAME
	detect_width_height $SRC_IMG
fi
DEST_IMG="${DEST_IMG_PATH}/${FILE_NAME}"


####################
### Thumbnail Conf
####################
thumbnail_conf() {
	local width=$1
	local height=$2
	local dest_width=$3
	local dest_height=$4

	local background=""
	local thumbnail=""
	local conf=""

	if [ $width -le $dest_width -a $height -le $dest_height ]; then
		thumbnail="${dest_width}x${dest_height}"
		background="-background black"
	elif [ $width -gt $dest_width -a $height -gt $dest_height ]; then
			#if [ $width -le $height ];then
					thumbnail="${dest_width}x${dest_height}"
					background="-background black"
			#else
			#        thumbnail="${dest_width}x${dest_height}^"
			#fi
	elif [ $width -gt $dest_width ];then
			#thumbnail="${dest_width}x${height}^"
			thumbnail="${dest_width}x${height}"
			background="-background black"
	elif [ $height -gt ${dest_height} ];then
			thumbnail="${dest_width}x${dest_height}"
			background="-background black"
	fi
	conf="$thumbnail $background"
	echo $conf
}
####################
### Thumbnail
####################
do_thumbnail() {
	local src_img=$1
	local width=$2
	local height=$3
	local dest_width=$4
	local dest_height=$5
	local dest_img=$6

	local conf=`thumbnail_conf $width $height $dest_width $dest_height`
	gm convert $src_img -thumbnail $conf -gravity center -extent $dest_widthx$dest_height $dest_img

	if [ $DELETE_SRC_LOCAL_FILE -eq 1 ]; then
		   rm -f $src_img
	fi

	#Write Log
	#REPLACE_TIME=$(date +%Y-%m-%d_%H:%M:%S)
	#echo -e "$REPLACE_TIME src_img:$SRC_IMG src_width:$WIDTH src_height:$HEIGHT $THUMBNAIL $BACKGROUND" >> $LOG_PATH
}

####################
### SnapShot
####################
do_snapshot() {
	local src_video=$1
	local dest_img=$2
	local offset=$3
	ffmpeg -i $src_video -y -f image2 -ss $offset -vframes 1 $dest_img
}
####################
### SubTitles
####################
do_subtitles() {
	echo "SubTitles"
	#gm convert -font Arial -fill red -pointsize 18 -draw "text 200,100 '5'" test.jpg gif5.jpg
	#gm convert -font ./simkai.ttf -fill red -pointsize 18 -draw "text 200,100 '烂柱子'" test.jpg test1.jpg
}
####################
### LeftRight
####################
do_leftright() {
	local src_img=$1
	local dest_img=$2
	gm convert -flop $src_img $dest_img

	if [ $DELETE_SRC_LOCAL_FILE -eq 1 ]; then
		   rm -f $src_img
	fi
}
####################
### UpDown
####################
do_updown() {
	local src_img=$1
	local dest_img=$2
	gm convert -flip $src_img $dest_img

	if [ $DELETE_SRC_LOCAL_FILE -eq 1 ]; then
		   rm -f $src_img
	fi
}
####################
### Scatter
####################
do_scatter() {
	local src_img=$1
	local dest_img=$2
	#9
	local degree=$3
	gm convert -spread $degree $src_img $dest_img

	if [ $DELETE_SRC_LOCAL_FILE -eq 1 ]; then
		   rm -f $src_img
	fi
}
####################
### Swirl
####################
do_swirl() {
	local src_img=$1
	local dest_img=$2
	#67
	local degree=$3
	gm convert -swirl $degree $src_img $dest_img

	if [ $DELETE_SRC_LOCAL_FILE -eq 1 ]; then
		   rm -f $src_img
	fi
}
####################
### Single Color
####################
do_single() {
	local src_img=$1
	local dest_img=$2
	gm convert -monochrome $src_img $dest_img

	if [ $DELETE_SRC_LOCAL_FILE -eq 1 ]; then
		   rm -f $src_img
	fi
}
####################
### Reverse Color
####################
do_reverse() {
	local src_img=$1
	local dest_img=$2
	gm convert -negate $src_img $dest_img

	if [ $DELETE_SRC_LOCAL_FILE -eq 1 ]; then
		   rm -f $src_img
	fi
}
####################
### Image Rotate
####################
do_rotate() {
	local src_img=$1
	local dest_img=$2
	#+25
	local degree=$3
	gm mogrify -rotate +$degree $src_img
	cp $src_img $dest_img

	if [ $DELETE_SRC_LOCAL_FILE -eq 1 ]; then
		   rm -f $src_img
	fi
}
####################
### Image Border
####################
do_border() {
	local src_img=$1
	local dest_img=$2
	#10x10
	local degree=$3
	local color=$4
	gm mogrify -border $degree -bordercolor $color $src_img
	cp $src_img $dest_img

	if [ $DELETE_SRC_LOCAL_FILE -eq 1 ]; then
		   rm -f $src_img
	fi
}
####################
### Image wave
####################
do_wave() {
	local src_img=$1
	local dest_img=$2
	#100x1000
	local degree=$3
	gm mogrify -wave $degree $src_img
	cp $src_img $dest_img

	if [ $DELETE_SRC_LOCAL_FILE -eq 1 ]; then
		   rm -f $src_img
	fi
}


support_list() {
	echo
    printf >&1 "Currently Support:\n"
	echo
    printf >&1 "       thumbnail	get a thumbnail from a image.\n"
    printf >&1 "       snapshot		generage a snapshot of a video.\n"
    printf >&1 "       subtitles	paste subtitles on the image.\n"
    printf >&1 "       leftright	invert the image left and right.\n"
    printf >&1 "       updown		invert the image up and down.\n"
    printf >&1 "       scatter		scatter the image.\n"
    printf >&1 "       swirl		swirl the image.\n"
    printf >&1 "       single		get single color of the image.\n"
    printf >&1 "       reverse		get reverse color of the image.\n"
    printf >&1 "       rotate		rotate the image.\n"
    printf >&1 "       border		border the image.\n"
    printf >&1 "       wave		wave the image.\n"
    echo
}
case $TYPE in
    thumbnail)
		do_thumbnail $SRC_IMG $WIDTH $HEIGHT $DEST_WIDTH $DEST_HEIGHT $DEST_IMG
		;;
    snapshot)
		do_snapshot $SRC_IMG $DEST_IMG $OFFSET
		;;
    #subtitles)
	#	do_subtitles
	#	;;
    leftright)
		do_leftright $SRC_IMG $DEST_IMG
		;;
    updown)
		do_updown $SRC_IMG $DEST_IMG
		;;
    scatter)
		do_scatter $SRC_IMG $DEST_IMG $LEVEL
		;;
    swirl)
		do_swirl $SRC_IMG $DEST_IMG $LEVEL
		;;
    single)
		do_single $SRC_IMG $DEST_IMG
		;;
    reverse)
		do_reverse $SRC_IMG $DEST_IMG
		;;
    rotate)
		do_rotate $SRC_IMG $DEST_IMG $LEVEL
		;;
    border)
		do_border $SRC_IMG $DEST_IMG $LEVEL $COLOR
		;;
    wave)
		do_wave $SRC_IMG $DEST_IMG $LEVEL
		;;
    *)
		support_list
		exit 0
		;;
esac
