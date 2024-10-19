#!/bin/bash

generate_test_data() {
    log_gir=$1
    size_mb=$2

    if [ ! -d "$log_gir" ]; then
        echo "[TEST] Error: Directory $log_gir do not exist"
        exit 1
    fi

    echo "[TEST] Creating files in $log_gir with overall size $size_mb MB..."

    file_size_mb=50
    num_files=$(($size_mb / $file_size_mb))

    for i in $(seq 1 $num_files); do
        echo "[TEST] Creating file $log_gir/test_file_$i.log with size $file_size_mb MB..."
        sudo dd if=/dev/zero of="$log_gir/test_file_$i.log" bs=1M count=$file_size_mb
    done

    echo "[TEST] Files generated successfully"
}

log_gir=${1:-"/LOG"}
threshold=${2:-70}
num_archive=${3:-5}

echo "Running tests..."
echo "Path to directory: $log_gir"
echo "Threshold: $threshold%"
echo "Number of archived files $num_archive"

echo "[TEST] Test 1: Usage below threshold"
generate_test_data "$log_gir" 200  
./log.sh "$log_gir" "$threshold" "$num_archive"

echo "------------------------------------"

echo "[TEST] Test 2: Usage above threshold"
generate_test_data "$log_gir" 600  
./log.sh "$log_gir" 5 "$num_archive"

echo "------------------------------------"

echo "[TEST] Test 3: Archiving exact number of files"
generate_test_data "$log_gir" 600
./log.sh "$log_gir" 50 3

echo "------------------------------------"

echo "[TEST] Test 4: Changing the archiving threshold"
generate_test_data "$log_gir" 600 
./log.sh "$log_gir" 50 "$num_archive"

echo "------------------------------------"

echo "[TEST] All tests are passed"
