#!/bin/bash
#
# replace.sh	Simple replace script that have a simple recovery function.
#
# processname: replace.sh
# description: Simple replace script that have a simple recovery function.
#
### BEGIN INIT INFO
# Provides: localtest
# Short-Description: Simple replace script that have a simple recovery function.
### END INIT INFO

# Source function library.
. /etc/rc.d/init.d/functions

prog=replace.sh
RETVAL=0

repl() {
    echo $"Replacing strings: "
    #save matched file lists.
    grep -r -l $3 $2 > ~/replace.log

    #make backup dir
    if [ ! -d ~/replace_backdir ]; then
    	mkdir ~/replace_backdir
    fi

    #保存备份地址
    #最好使用绝对路径
    echo $2 >> ~/replace_backdir/back.txt

    #copy file to backup dir(Stay directory structrue)
    tar -zcvf ~/replace_backdir/back.tar.gz `grep -r -l $3 $2`

    #replace matched file lists.
    sed -i -e s/$3/$4/g `grep -r -l $3 $2`
}

reco() {
    echo $"Recovering files: "
    tar -zxvf ~/replace_backdir/back.tar.gz -C `cat ~/replace_backdir/back.txt`
}

help() {
    echo "-------------------------------------------------------";
    echo $"Help info: "
    echo "1.repl——replace the strings in the specialed directory."
    echo "	Param: 1.directory 2.source string 3.target strings"
    echo "2.reco——recovery the last replacing action"
    echo "	Param: None para"
    echo "3.help——echo detail help info"
    echo "	Param: None para"
    echo "-------------------------------------------------------";
}

# See how we were called.
case "$1" in
    help)
    	help
    	;;
    version)
    	echo "v0.1";
        ;;
    repl)
    	repl $*
        ;;
    reco)
    	reco
        ;;
    *)
        echo $"Usage: $prog {repl|reco|version|help}"
        RETVAL=2
esac

exit $RETVAL
