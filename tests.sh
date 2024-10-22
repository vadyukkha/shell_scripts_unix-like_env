#!/bin/bash

generate_test_data() {
    log_dir=$1
    num_files=$2
    start_size_mb=${3:-1}
    size_step=${4:-1}

    if [ -z "$log_dir" ]; then
        echo "[TEST] Error: Directory path not provided. Use ./tests.sh /directory_name ."
        exit 1
    fi

    if [ ! -d "$log_dir" ]; then
        echo "[TEST] Error: Directory $log_dir do not exist."
        exit 1
    fi

    if [ $num_files -lt 1 ]; then
 echo "[TEST] Error: Num of files must be more or equal than 1."
        exit 1
    fi

    if [ $start_size_mb -lt 1 ]; then
     echo "[TEST] Error: Start size of files must be more or equal than 1."
     exit 1
    fi

    if [ $size_step -lt 1 ]; then
 echo "[TEST] Error: Size step must be more or equal than 1."
 exit 1
    fi

    for (( i=$start_size_mb; i <= $num_files * $size_step; i += $size_step )) do
        echo "[TEST] Creating file $log_dir/test_file_$i.log with size $i MB..."
        sudo dd if=/dev/zero of="$log_dir/test_file_$i.log" bs=1M count=$(( $i*$start_size_mb ))
    done

    echo "[TEST] Files generated successfully"
}

log_dir=${1:-"/LOG"}
threshold=${2:-70}
num_archive=${3:-5}

echo "Running tests..."
echo "Path to directory: $log_dir"
echo "Threshold: $threshold%"
echo "Number of archived files $num_archive"

echo "------------------------------------"

echo "[TEST] Test 1: Usage below threshold"
generate_test_data "$log_dir" 5 20 20
./log.sh "$log_dir" "$threshold" "$num_archive"

echo "------------------------------------"

echo "[TEST] Test 2: Usage above threshold"
generate_test_data "$log_dir" 30
./log.sh "$log_dir" 5 "$num_archive"

echo "------------------------------------"

echo "[TEST] Test 3: Archiving exact number of files"
generate_test_data "$log_dir" 30 1 3

./log.sh "$log_dir" 50 3

echo "------------------------------------"

echo "[TEST] Test 4: Number of files is less than number for archiving"
generate_test_data "$log_dir" 20
./log.sh "$log_dir" 5 100

echo "------------------------------------"

echo "[TEST] Test 5: Invalid threshold"
generate_test_data "$log_dir" 15
./log.sh "$log_dir" 150 "$num_archive"

echo "------------------------------------"

echo "[TEST] Test 6: Invalid directory path"
generate_test_data "$log_dir" 15
./log.sh "/asdasdasd" "threshold" "$num_archive"

echo "------------------------------------"

echo "[TEST] Test 7: Missed directory path"
generate_test_data "$log_dir" 15
./log.sh

echo "------------------------------------"

echo "[TEST] All tests are passed"
