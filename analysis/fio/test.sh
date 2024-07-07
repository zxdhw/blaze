#!/bin/bash

# 设置FIO测试参数
block_sizes=("4K" "128K")
# block_sizes=( "16K" "32K" "64K" "128K")
threads=("1" "2" "4" "8" "12" "16")
iodepth=("128")
# iodepth=("1" "2" "4" "8" "16" "32" "64" "96" "128" "256" "512")
duration=60

# 执行FIO测试

for block_size in "${block_sizes[@]}"; do
    run_folder="P4610_nromal/${block_size}"
    mkdir -p $run_folder
    for thread in "${threads[@]}"; do
        for depth in "${iodepth[@]}"; do
            log_file="$run_folder/fio_${block_size}_${thread}_${depth}.log"
            sudo fio --name=test  --filename=/dev/nvme1n1 --ioengine=libaio --rw=randread --iodepth=$depth --bs=$block_size \
                --numjobs=$thread --size=10G --thread --direct=1 --runtime=$duration > $log_file
        done
    done
done
