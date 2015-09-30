My_shell
====

My own shell —— welcome give advice to me!

1. replace.sh	Simple replace script that have a simple recovery function.<br/>
2. rm_back.sh	Simple delete script that have a simple recovery function(unover).<br/>

3. cover.sh	Very simple script to process image.(cover.sh是一个非常简单的的图片处理封装)<br/>

		Note:

			a. You need install the GraphicsMagick before useing it.
			b. You'd better install the mediaInfo if you don't want to pass the param width or height.

			a. 如果使用它，你需要事先安装GraphicsMagick工具
			b. 如果你不想手工指定源图片的宽高, 最好安装mediaInfo工具

		Usage:

			Convert Image: ./cover.sh <-t convert> <-e effect> <-w width> <-h height> <-d delete> <-W width> <-H width> <-o offset> <-m target name> <-l level> <-f address>

				   -t process type.
				   -e special effect.
				   -w source image width.
				   -h source image height.
				   -d delete source file.
				   -W source image width.
				   -H source image height.
				   -o offset.
				   -m target name.
				   -l process level.
				   -f source image file.

		Currently Support Type:

				thumbnail        get a thumbnail from a image.
				snapshot         generage a snapshot of a video.
				subtitles        paste subtitles on the image.
				leftright        invert the image left and right.
				updown           invert the image up and down.
				scatter          scatter the image.
				swirl            swirl the image.
				single           get single color of the image.
				reverse          get reverse color of the image.
				rotate           rotate the image.
				border           border the image.
				wave             wave the image.

		Eg:

		./cover.sh -t thumbnail -f https://www.baidu.com/img/270newhuanfu_8509d24b1b3b997246d712cd11971428.png -m test.png -d
		./cover.sh -t snapshot -f "http://k.youku.com/player/getFlvPath/sid/44435951875871018b092_01/st/flv/fileid/030002070150F82828DA5701F9834DAD41561B-D04A-49D3-E752-480D0E814DAF?K=d32fc5b46f5451ca24125b33&ctype=10&ev=1&oip=2043096855&token=7762&ep=TDp%2FMUFAHofApmkyPYIoZLyaqtYPjVuXwlKSVw%2B%2F5cASHsb%2BC0DuknwWQ6%2Fymj2%2BQTu3JF9MUGw7Lp801bR%2Bd9WGNlIB0TnSfwAQVPxETVGE0nb1XX8WueU%2BVOy33hXembWLqkBcyJs%3D&ymovie=1" -o 60 -m snapshot.jpg
		./cover.sh -t leftright -f https://www.baidu.com/img/270newhuanfu_8509d24b1b3b997246d712cd11971428.png -m test.png -d
		./cover.sh -t updown -f https://www.baidu.com/img/270newhuanfu_8509d24b1b3b997246d712cd11971428.png -m test.png -d
		./cover.sh -t scatter -f https://www.baidu.com/img/270newhuanfu_8509d24b1b3b997246d712cd11971428.png -m test.png -d -l 6
		./cover.sh -t swirl -f https://www.baidu.com/img/270newhuanfu_8509d24b1b3b997246d712cd11971428.png -m test.png -d -l 67
		./cover.sh -t single -f https://www.baidu.com/img/270newhuanfu_8509d24b1b3b997246d712cd11971428.png -m test.png -d
		./cover.sh -t reverse -f https://www.baidu.com/img/270newhuanfu_8509d24b1b3b997246d712cd11971428.png -m test.png -d
		./cover.sh -t rotate -f https://www.baidu.com/img/270newhuanfu_8509d24b1b3b997246d712cd11971428.png -m test.png -d -l 25
		./cover.sh -t border -f https://www.baidu.com/img/270newhuanfu_8509d24b1b3b997246d712cd11971428.png -m test.png -d -l 10x10 -c red
		./cover.sh -t wave -f https://www.baidu.com/img/270newhuanfu_8509d24b1b3b997246d712cd11971428.png -m test.png -d -l 100x1000

<br/>
4. export.sh	Very Simple Script To Export Data From Mysql<br/>

		Eg: ./export.sh "Use testdb; SELECT \`id\` FROM \`testtable\` WHERE xxx" ./testid.log
