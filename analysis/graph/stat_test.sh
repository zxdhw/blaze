#!/bin/bash

pagetime='/home/zxd/blaze/analysis/graph/breakdown/bfs_libaio_16k_D1_spinirq'

# cat ${pagetime} | awk '/----/ {print $5 $10}' > ${pagetime}.read_bw.log

# #aio time
# awk '/----aio time/ {
#     match($0, /is ([0-9]+),.*is ([0-9]+)/, arr)
#     print arr[1], arr[2]
#     sum += arr[1]
#     count += arr[2]
# } END {
#     print "Sum is: ", sum,  "Count is: ",count,  "Average is: ", sum/count 
# }' ${pagetime}.out > ${pagetime}_aio_time.txt

# #aio hit time
# awk '/----aio hit time/ {
#     match($0, /is ([0-9]+),.*is ([0-9]+)/, arr)
#     print arr[1], arr[2]
#     sum += arr[1]
#     count += arr[2]
# } END {
#     print "Sum is: ", sum,  "Count is: ",count,  "Average is: ", sum/count 
# }' ${pagetime}.out > ${pagetime}_aio_hit_time.txt

# #fs time
# awk '/----fs time/ {
#     match($0, /is ([0-9]+),.*is ([0-9]+)/, arr)
#     print arr[1], arr[2]
#     sum += arr[1]
#     count += arr[2]
# } END {
#     print "Sum is: ", sum,  "Count is: ",count,  "Average is: ", sum/count 
# }' ${pagetime}.out > ${pagetime}_fs_time.txt

# #block time
# awk '/----block time/ {
#     match($0, /is ([0-9]+),.*is ([0-9]+)/, arr)
#     print arr[1], arr[2]
#     sum += arr[1]
#     count += arr[2]
# } END {
#     print "Sum is: ", sum,  "Count is: ",count,  "Average is: ", sum/count 
# }' ${pagetime}.out > ${pagetime}_block_time.txt

# #driver time
# awk '/----driver time/ {
#     match($0, /is ([0-9]+),.*is ([0-9]+)/, arr)
#     print arr[1], arr[2]
#     sum += arr[1]
#     count += arr[2]
# } END {
#     print "Sum is: ", sum,  "Count is: ",count,  "Average is: ", sum/count 
# }' ${pagetime}.out > ${pagetime}_driver_time.txt

# #iomao time
# awk '/----iomap time/ {
#     match($0, /is ([0-9]+),.*is ([0-9]+)/, arr)
#     print arr[1], arr[2]
#     sum += arr[1]
#     count += arr[2]
# } END {
#     print "Sum is: ", sum,  "Count is: ",count,  "Average is: ", sum/count 
# }' ${pagetime}.out > ${pagetime}_iomap_time.txt

# #get page
# awk '/----get page/ {
#     match($0, /is ([0-9]+),.*is ([0-9]+)/, arr)
#     print arr[1], arr[2]
#     sum += arr[1]
#     count += arr[2]
# } END {
#     print "Sum is: ", sum,  "Count is: ",count,  "Average is: ", sum/count 
# }' ${pagetime}.out > ${pagetime}_page_time.txt

#bio time
# awk '/----bio time/ {
#     match($0, /is ([0-9]+),.*is ([0-9]+)/, arr)
#     print arr[1], arr[2]
#     sum += arr[1]
#     count += arr[2]
# } END {
#     print "Sum is: ", sum,  "Count is: ",count,  "Average is: ", sum/count 
# }' ${pagetime}.out > ${pagetime}_bio_time_test.txt

# #req time
# awk '/----req time/ {
#     match($0, /is ([0-9]+),.*is ([0-9]+)/, arr)
#     print arr[1], arr[2]
#     sum += arr[1]
#     count += arr[2]
# } END {
#     print "Sum is: ", sum,  "Count is: ",count,  "Average is: ", sum/count 
# }' ${pagetime}.out > ${pagetime}_req_time.txt

# #dma time
# awk '/----dma time/ {
#     match($0, /is ([0-9]+),.*is ([0-9]+)/, arr)
#     print arr[1], arr[2]
#     sum += arr[1]
#     count += arr[2]
# } END {
#     print "Sum is: ", sum,  "Count is: ",count,  "Average is: ", sum/count 
# }' ${pagetime}.out > ${pagetime}_dma_time.txt

# #sq time
awk '/----sq time/ {
    match($0, /is ([0-9]+),.*is ([0-9]+)/, arr)
    print arr[1], arr[2]
    sum += arr[1]
    count += arr[2]
} END {
    print "Sum is: ", sum,  "Count is: ",count,  "Average is: ", sum/count 
}' ${pagetime}.out > ${pagetime}_sq_time.txt

# #sq time
awk '/----sq cpy time/ {
    match($0, /is ([0-9]+),.*is ([0-9]+)/, arr)
    print arr[1], arr[2]
    sum += arr[1]
    count += arr[2]
} END {
    print "Sum is: ", sum,  "Count is: ",count,  "Average is: ", sum/count 
}' ${pagetime}.out > ${pagetime}_sq_cpy_time.txt

# #sq time
awk '/----sq write time/ {
    match($0, /is ([0-9]+),.*is ([0-9]+)/, arr)
    print arr[1], arr[2]
    sum += arr[1]
    count += arr[2]
} END {
    print "Sum is: ", sum,  "Count is: ",count,  "Average is: ", sum/count 
}' ${pagetime}.out > ${pagetime}_sq_write_time.txt

# #sq time
awk '/----lock time/ {
    match($0, /is ([0-9]+),.*is ([0-9]+)/, arr)
    print arr[1], arr[2]
    sum += arr[1]
    count += arr[2]
} END {
    print "Sum is: ", sum,  "Count is: ",count,  "Average is: ", sum/count 
}' ${pagetime}.out > ${pagetime}_lock_time.txt