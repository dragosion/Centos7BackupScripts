# Centos7BackupScripts
Centos7BackupScripts

Anyone interested to collaborate or use this is more than welcomed.
Compiled bits of info into one script.
Lots of things need improving but hopefully not for long.


Copy script to to /etc/dibackup/backup-tar-script.sh


crontab -e
add one new line

10 8 * * 3 /bin/sh /etc/dibackup/backup-tar-script.sh >> /var/log/dibackup-backup-tar.log 2>&1

it will run:
>>> Every Wednesday at 8:10 AM UTC

check log
cat /var/log/dibackup-backup-tar.log

Manually sftp files offsite or
add rsync option for remote ssh.
