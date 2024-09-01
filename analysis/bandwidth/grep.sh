#!/bin/bash

# 定义文件夹路径
DIRECTORY="/home/zhengxd/blaze/analysis/bandwidth/result/bc"

# 遍历文件夹中的所有文件
for FILE in "$DIRECTORY"/*; do
    # 获取文件名
    FILENAME=$(basename "$FILE")

    # 使用正则表达式提取 hitchhike1, batch1 和 D128 中的信息
    if [[ $FILENAME =~ hitqueue([0-9]+).*ioqueue([0-9]+) ]]; then
        hitqueue=${BASH_REMATCH[1]}
        ioqueue=${BASH_REMATCH[2]}
    fi

    # 从文件中读取包含 "Hitchhike read:" 的行并提取 IOPS 值
    IOPS=$(grep "IO SUMMARY hit" "$FILE" | awk -F 'IOPS=' '{print $2}' | awk -F  ' '  '{print $(NF-1)}')

    # 输出提取的信息
    # echo "File: $FILENAME" >> iops.out
    # echo "Hitchhike: $HITCHHIKE, Batch: $BATCH, Depth: $DEPTH, IOPS: $IOPS" >> iops.out
     echo "$hitqueue, $ioqueue, $IOPS" >> iops.out
    # echo "---------------------------------"
done
