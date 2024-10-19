#!/bin/bash

# Parameters
# $1 - folder that should be logged
# $2 - Max usage percentage (default 70%)

log_dir=$1
threshold=${2:-70}

usage=$(df "$log_dir" | awk 'NR==2 {print $5}' | sed 's/%//')

if [ $usage -ge $threshold ]; then
    echo "The current usage $usage% over $threshold."
else
    echo "Enough free place in a folder $log_dir. Current usage: $usage%. Threshold: $threshold."
fi
