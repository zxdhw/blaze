#!/bin/bash


#path
APP_PATH=/home/zhengxd/blaze/build/bin
INDEX=/home/zhengxd/dataset/mnt/samsung5/
DATA=/home/zhengxd/dataset/mnt/samsung5/
RESULT=/home/zhengxd/blaze/analysis/graph/haslab19/

# parameter
COMPUTEWORKERS=16
HIT=1
TIMES=1
STARTNODE=50395005

# libaio arg
declare -a depth=("128")
# declare -a depth=("1" "2" "4" "8" "16" "32" "64" "128" "256" "512" "1024")
# declare -a depth=("1" "2" "4" "6" "8" "12" "16" "20" "24" "28" "32" "64" "128" "256" "512" "1024")

#hit arg
declare -a hitSize=("64")
# declare -a hitSize=("1" "2" "4" "8" "16" "32" "64")
# declare -a hitSize=("1" "2" "4" "8" "16" "32" "64" "96" "127" "3" "6" "10" "12" "14" "18" "20" "24" "28" "36" "40" "44" "48" "52" "56" "60")
# declare -a hitSize=("2" "3" "4" "6" "8" "12" "16" "20" "24" "32" "48" "64" "96" "127")
# declare -a hitSize=("16" "20" "24" "32" "48" "64" "96" "127")


# common arg
declare -a apps=("bfs")
declare -a index=("sk2005.gr.index")
declare -a data=("sk2005.gr.adj.0")
# declare -a index=("rmat30.gr.index")
# declare -a data=("rmat30.gr.adj.0")
#"rmat27.gr.index" "rmat30.gr.index" "uran27.gr.index" 
# declare -a apps=("bfs" "bc" "pagerank" "wcc" "spmv")

# CPU
# cpu_filename='cpu_output'
# runtime=15
# frequency=1
# sar -P 1-16 ${frequency}  ${runtime}  > ${cpu_filename}.out &


# libaio test
# for ((n=0; n<TIMES; n++)); do
#     for e in "${apps[@]}"; do
#         for qd in "${depth[@]}"; do
#             for ((i=0; i<${#index[@]}; i++)); do
#                 k="${index[i]}"
#                 j="${data[i]}"
#                 sudo $APP_PATH/${e} -computeWorkers $COMPUTEWORKERS -startNode $STARTNODE -queueDepth $qd -hit $HIT  $INDEX/${k} $DATA/${j} >> ${RESULT}/bfs_libaio_nomerge_4k_D${qd}.out
#                 # > breakdown_nomerge_qd128.out
#                 # >> ${RESULT}/bfs_libaio_nomerge_4k_D${qd}.out
#             done
#         done
#     done
# done

#hit test

# for ((n=0; n<TIMES; n++)); do
for h in "${hitSize[@]}"; do
    for e in "${apps[@]}"; do
        for qd in "${depth[@]}"; do
            for ((i=0; i<${#index[@]}; i++)); do
                k="${index[i]}"
                j="${data[i]}"
                sudo $APP_PATH/${e} -computeWorkers $COMPUTEWORKERS -startNode $STARTNODE -hit $HIT -queueDepth $qd -hitSize ${h} $INDEX/${k} $DATA/${j} > test.out
                # ${RESULT}/bfs_libaio_nomerge_D${qd}.out
                # >> ${RESULT}/bfs_hit_H${h}_D${qd}.out
                # sudo $APP_PATH/${e} -computeWorkers $COMPUTEWORKERS -hit $HIT -queueDepth $qd -hitSize ${h} $INDEX/${k} $DATA/${j} >> test.out
                # >> ${RESULT}/bfs_hit_H${h}_D${qd}.out
                # >> test.out
                # >> ${RESULT}/bfs_hit_H${h}_D${qd}.out
                # >> breakdown_hit${h}_qd1.out
                # -hit $HIT -queueDepth $qd 
            done
        done
    done
done
#done


#CPU

# killall sar

# cat ${cpu_filename}.out | awk '/12时/ {print $8}' > ${cpu_filename}_io.log
# awk '
#   BEGIN {
#     sum = 0
#     count = 0
#   }
#   /^%idle$/ {
#     if (count > 0) {
#       average = 100-(sum / count)
#       print "Average %util:", average > "${cpu_filename.awk}.read_bw.log"
#     }
#     sum = 0
#     count = s
#     next
#   }
#   NF == 1 {
#     sum += $1
#     count += 1
#   }
#   END {
#     if (count > 0) {
#       average = 100-(sum / count)
#       print "Average %util:", average > "${cpu_filename.awk}.read_bw.log"
#     }
#   }
# ' ${cpu_filename}.read_bw.log
# cat ${io_filename}.out | awk '/nvme/ {print $3}' > ${io_filename}.read_bw.log