#!/bin/bash

if [ "$2" == "" ]; then
    echo "Usage: $0 /etc/lightdatasys/mariadb/backup/my.cnf /home/boxkeeper/backup/snapshot/databases"
    exit 1
fi

MY_CNF_FILE=$1
DATE=$(date +%F)
BACKUP_DIR="$2/$DATE"

mkdir -p "$BACKUP_DIR"

for DATABASE in $(mysql --defaults-extra-file="$MY_CNF_FILE" -N -e 'show databases'); do
    if [[ $DATABASE == "information_schema" || $DATABASE == "performance_schema" ]]; then
        continue
    fi

    mysqldump --defaults-extra-file="$MY_CNF_FILE" "$DATABASE" | gzip >"$BACKUP_DIR/$DATABASE.sql.gz"
done
