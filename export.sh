###
## Very Simple Script To Export Data From Mysql
###

set -o nounset

SQL=$1
DATA_FILE=$2

HOST=''
PORT=''
USER=''
PASSWD=''

mysql -h $HOST -P $PORT -u $USER -p$PASSWD -Ne "${SQL}" > $DATA_FILE
