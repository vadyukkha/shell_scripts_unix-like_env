#!/bin/bash

# Parameters
# $1 - folder that should be logged
# $2 - Max usage percentage (default 70%)
# $3 - Number of files to archive (default 5)

log_dir=$1
threshold=${2:-70}
num_archive=${3:-5}
backup_dir='/BACKUP'

if [$log_dir -eq '']; then
    echo "[LOG] Error: directory was not requests. Hint: ./log.sh /Name_of_directiry"
    exit 1
fi

usage=$(df "$log_dir" | awk 'NR==2 {print $5}' | sed 's/%//')

if [ $usage -ge $threshold ]; then
    echo "[LOG] The current usage $usage% over $threshold%. Starting to archive files..."

    mkdir -p "$backup_dir"

    files=$(ls -1t $log_dir | head -n $num_archive)
    
    if [ -z "$files" ]; then
        echo "[LOG] ERROR: Files not found in folder $log_dir"
        exit 1
    fi

    sudo tar -czf $backup_dir/backup_$(date +%Y%m%d%_H%M%S).tar.gz -C $log_dir $files

    for file in $files; do
        echo "[LOG] Removing file $file from $log_dir"
        sudo rm -f $log_dir/$file
    done
else
    echo "[LOG] Enough free place in a folder $log_dir. Current usage: $usage%. Threshold: $threshold."
fi
