#!/bin/bash

# 记录开始时间
DEV_NAME='/dev/nvme0n1'
DEV_ID=`basename $DEV_NAME`


start_time=$(date +%s)

while true; do
    # 记录当前时间
    current_time=$(date +%s)
    
    # 计算运行时间
    elapsed_time=$((current_time - start_time))
    
    # 检查是否已经运行了10秒
    if [ $elapsed_time -ge 10 ]; then
        break
    fi
    
    # 将 /proc/diskstats 内容追加到文件中
    cat /proc/diskstats >> ${DEV_ID}_info.out
    sleep 0.01
done


cat ${DEV_ID}_info.out | awk '/nvme0n1/ {print $12}' >  ${DEV_ID}_Flight.log