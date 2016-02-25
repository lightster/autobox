#!/bin/bash

if [ "$2" == "" ]; then
    echo "Usage: $0 smart /home/boxkeeper/backup/snapshot/databases/ ~/backup/snapshot/smart/databases/"
    exit 1
fi

REMOTE_HOSTNAME=$1
REMOTE_BACKUP_DIR=$2
LOCAL_BACKUP_DIR=$3

mkdir -p "$LOCAL_BACKUP_DIR"

rsync -az $REMOTE_HOSTNAME:"$REMOTE_BACKUP_DIR" "$LOCAL_BACKUP_DIR"
