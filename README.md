My_shell
====

My own shell —— welcome give advice to me!

1. replace.sh	Simple replace script that have a simple recovery function.<br/>
2. rm_back.sh	Simple delete script that have a simple recovery function(unover).<br/>

3. cover.sh	Very simple script to process image.<br/>

		Note:

			a. You need install the GraphicsMagick before useing it.
			b. You'd better install the mediaInfo if you don't want to pass the param width or height

		Format:

		./cover.sh $sourceImgUrl $imageWidth $imageHeight $ifDeleteSource(Tmp)File

		Eg: ./cover.sh "http://" 600 600
<br/>
4. export.sh	Very Simple Script To Export Data From Mysql<br/>

		Eg: ./export.sh "Use testdb; SELECT \`id\` FROM \`testtable\` WHERE xxx" ./testid.log
