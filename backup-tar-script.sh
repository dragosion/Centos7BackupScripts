#!/bin/bash
#Dragos Ion - Backup mysql, www, home and etc
# 2019.03.05

function myecho() {
        echo "`date +%y/%m/%d_%H:%M:%S`:: $@"
}

#MYSQL
USER="<<your_mysql_username>>"
PASSWORD="<<your_mysql_password>>"
MYSQLOUTPUT="/var/dibackup/db-backup"


HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root

if [ ! -d "/var/dibackup/" ]; then
  mkdir /var/dibackup/
fi

if [ ! -d "/var/dibackup/db-backup/" ]; then
  mkdir /var/dibackup/db-backup/
fi

datetxt=$(date '+%Y-%m-%d-%H-%M-%S')


rm -- "$MYSQLOUTPUT"/*.sql

databases=`mysql -u $USER -p$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != _* ]] ; then
        myecho "Dumping database: $db to $MYSQLOUTPUT/$db-$datetxt.sql"
        mysqldump -u $USER -p$PASSWORD --databases $db > $MYSQLOUTPUT/$db-$datetxt.sql
    fi
done
#MYSQL END

myecho "tar.gz BEGIN"
# Backup files and .sql files dump
tar -czf /var/dibackup/backup-$datetxt.tar.gz /etc/ /home/ /var/www/ /var/dibackup/db-backup/
myecho "tar.gz DONE"

myecho "remove old *.gz files from /var/dibackup/ older than 30 days"
find /var/dibackup/ -type f -name '*.gz' -mtime +30 -exec rm {} \;

myecho "**** all finished ****"
