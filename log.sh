#!/bin/bash

# Parameters
# $1 - folder that should be logged
# $2 - Max usage percentage (default 70%)
# $3 - Number of files to archive (default 5)

log_dir=$1
threshold=${2:-70}
num_archive=${3:-5}
backup_dir='/BACKUP'

if [ -z "$log_dir" ]; then
    echo "[LOG] Error: Directory path not provided. Use ./log.sh /directory_name ."
    exit 1
fi

if [ ! -d "$log_dir" ]; then
    echo "[LOG] Error: Directory $log_dir does not exist."
    exit 1
fi

if [[ $threshold -lt 1 || $threshold -gt 100 ]]; then
    echo "[LOG] Error: Invalid threshold value. It must beetwen 1 and 100."
    exit 1
fi

usage=$(df "$log_dir" | awk 'NR==2 {print $5}' | sed 's/%//')

if [ $usage -ge $threshold ]; then
    echo "[LOG] The current usage $usage% over $threshold%. Starting to archive files..."

    mkdir -p "$backup_dir"

    files=$(ls -1t $log_dir | head -n $num_archive)

    all_count_files=$(ls -1A $log_dir | grep -v 'lost+found' | wc -l)
    file_paths=""
    for file in $(ls -1t $log_dir | head -n $all_count_files); do
        if [ -d "$log_dir/$file" ]; then
            continue
        fi
        file_paths="$file_paths $log_dir/$file"
    done
    file_sizes=$(stat --format="%s" $file_paths)
    
    total_size=$(echo "$file_sizes" | awk '{s+=$1} END {print s}')
    max_size_file=$(echo "$file_sizes" | sort -n | tail -1)
    min_size_file=$(echo "$file_sizes" | sort -n | head -1)
    avg_size_file=$(echo "$total_size/$all_count_files" | bc)
    
    echo "[LOG] Max size file: $max_size_file bytes"
    echo "[LOG] Min size file: $min_size_file bytes"
    echo "[LOG] Avg size file: $avg_size_file bytes"
    
    if [ -z "$files" ]; then
        echo "[LOG] ERROR: Files not found in folder $log_dir"
        exit 1
    fi

    sudo tar -czf $backup_dir/backup_$(date +%Y%m%d%_H%M%S).tar.gz -C $log_dir $files
    echo "[LOG] Files was archived successfully"

    for file in $files; do
        if [ -d "$log_dir/$file" ]; then
            continue
        fi
        echo "[LOG] Removing file $file from $log_dir"
        sudo rm -f $log_dir/$file
    done
else
    echo "[LOG] Enough free place in a folder $log_dir. Current usage: $usage%. Threshold: $threshold."
fi
