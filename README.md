My_shell
====

My own shell —— welcome give advice to me!

1. replace.sh	Simple replace script that have a simple recovery function.<br/>
2. rm_back.sh	Simple delete script that have a simple recovery function(unover).<br/>

3. cover.sh	Very simple script to process image.(cover.sh是一个非常简单的的图片处理封装)<br/>

		Note:

			a. You need install the GraphicsMagick before useing it(如果使用它，你需要事先安装GraphicsMagick工具).
			b. You'd better install the mediaInfo if you don't want to pass the param width or height(如果你不想手工指定源图片的宽高, 最好安装mediaInfo工具).

		Usage:

			Convert Image: ./cover.sh <-t convert> <-e effect> <-w width> <-h height> <-d delete> <-W width> <-H width> <-f address>

			   -t process type.
			   -e special effect.
			   -w source image width.
			   -h source image height.
			   -d delete source file.
			   -W source image width.
			   -H source image height.
			   -f source image file.
<br/>
4. export.sh	Very Simple Script To Export Data From Mysql<br/>

		Eg: ./export.sh "Use testdb; SELECT \`id\` FROM \`testtable\` WHERE xxx" ./testid.log
