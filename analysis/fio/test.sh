#!/bin/bash

# 设置FIO测试参数
block_sizes=("4K" "8K" "16K" "32K" "64K" "128K")
# block_sizes=( "16K" "32K" "64K" "128K")
threads=("1")
iodepth=("1" "2" "4" "8" "16" "32" "64" "96" "128" "256" "512")
duration=60

# 创建保存日志的文件夹
# mkdir -p fio_logs

# 执行FIO测试
  # run_folder="fio_logs/"
  # mkdir -p $run_folder

for block_size in "${block_sizes[@]}"; do
    run_folder="fio_logs/${block_size}"
    mkdir -p $run_folder
    for thread in "${threads[@]}"; do
        for depth in "${iodepth}"; do
            log_file="$run_folder/fio_${block_size}_${thread}.log"
            sudo fio --name=test  --filename=/dev/nvme0n1 --ioengine=libaio --rw=randread --iodepth=$depth --bs=$block_size \
                --numjobs=$thread --size=10G --thread --direct=1 --runtime=$duration > $log_file
        done
    done
done
