#!/bin/bash

pagetime='/home/zxd/blaze/analysis/graph/bfs_hit_H32K_D128'

# cat ${pagetime} | awk '/----/ {print $5 $10}' > ${pagetime}.read_bw.log
awk '/----/ {
    match($0, /is ([0-9]+),.*is ([0-9]+)/, arr)
    print arr[1], arr[2]
    sum += arr[1]
    count += arr[2]
} END {
    print "Sum is: ", sum,  "Count is: ",count,  "Average is: ", sum/count 
}' ${pagetime}.out > ${pagetime}_time.txt


