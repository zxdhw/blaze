#!/bin/bash
# sudo ~/blaze/build/bin/bfs -computeWorkers 16 -startNode 0 /home/zhengxd/mnt/nvme/sc22/rmat27.gr.index /home/zhengxd/mnt/nvme/sc22/rmat27.gr.adj.0 
# sudo ~/blaze/build/bin/bfs -computeWorkers 8 -startNode 0 /home/zhengxd/mnt/nvme1/sc22/rmat27.gr.index /home/zhengxd/mnt/nvme1/sc22/rmat27.gr.adj.0  
# sudo ~/blaze/build/bin/bfs -computeWorkers 16 -startNode 12 /home/zhengxd/mnt/nvme/sc22/twitter.gr.index /home/zhengxd/mnt/nvme/sc22/twitter.gr.adj.0  
# sudo ~/blaze/build/bin/bfs -computeWorkers 16 -startNode 50395005 /home/zhengxd/mnt/nvme/sc22/sk2005.gr.index /home/zhengxd/mnt/nvme/sc22/sk2005.gr.adj.0 
# sudo ~/blaze/build/bin/bfs -computeWorkers 16 -startNode 0 /home/zhengxd/mnt/nvme/sc22/uran27.gr.index /home/zhengxd/mnt/nvme/sc22/uran27.gr.adj.0 
# sudo ~/blaze/build/bin/bfs -computeWorkers 16 -startNode 0 /home/zhengxd/mnt/nvme2/sc22/rmat27.gr.index /home/zhengxd/mnt/nvme2/sc22/rmat27.gr.adj.0 
# sudo ~/blaze/build/bin/bfs -computeWorkers 16 -startNode 101 /home/zhengxd/mnt/nvme1/sc22/friendster.gr.index /home/zhengxd/mnt/nvme1/sc22/friendster.gr.adj.0 


#path
# SCRIPT_PATH=`realpath $0`
# BASE_DIR=`dirname $SCRIPT_PATH`

APP_PATH=$HOME/blaze/build/bin
# APP_PATH='/home/femu/blaze-old/blaze/build/bin'
INDEX=$HOME/dataset/mnt/nvme_haslab2
DATA=$HOME/dataset/mnt/nvme_haslab2
RESULT=$HOME/blaze/analysis/graph/P4510

# parameter
COMPUTEWORKERS=14
STARTNODE=50395005
# 101
HIT=1
TIMES=1
qd=1

# declare -a hitSize=("32" "64" "96" "127")

declare -a hitSize=("1")
declare -a apps=("bfs")
#data and index
declare -a index=("sk2005.gr.index")
declare -a data=("sk2005.gr.adj.0")
# declare -a index=("friendster.gr.index")
# declare -a data=("friendster.gr.adj.0")
#"rmat27.gr.index" "rmat30.gr.index" "uran27.gr.index" 
# declare -a apps=("bfs" "bc" "pagerank" "wcc" "spmv")

# for ((n=0; n<TIMES; n++)); do
#     for e in "${apps[@]}"; do
#         for ((i=0; i<${#index[@]}; i++)); do
#             k="${index[i]}"
#             j="${data[i]}"
#             # sudo $APP_PATH/${e} -computeWorkers $COMPUTEWORKERS -startNode $STARTNODE -ebpf $HIT $INDEX/${k} $DATA/${j} > ${RESULT}/magazine_${COMPUTEWORKERS}_${e}.out
#             sudo $APP_PATH/${e} -computeWorkers $COMPUTEWORKERS -hit $HIT -startNode $STARTNODE $INDEX/${k} $DATA/${j} > data.txt
#         done
#     done
# done

# for ((n=0; n<TIMES; n++)); do
#     for e in "${apps[@]}"; do
#         for ((i=0; i<${#index[@]}; i++)); do
#             k="${index[i]}"
#             j="${data[i]}"
#             sudo $APP_PATH/${e} -computeWorkers $COMPUTEWORKERS -startNode $STARTNODE -queueDepth $qd -hit $HIT $INDEX/${k} $DATA/${j} >> ${RESULT}/bfs_libaio_nomerge_4k_D${qd}.out
#         done
#     done
# done

for ((n=0; n<TIMES; n++)); do
    for h in "${hitSize[@]}"; do
        for e in "${apps[@]}"; do
            for ((i=0; i<${#index[@]}; i++)); do
                k="${index[i]}"
                j="${data[i]}"
                # sudo $APP_PATH/${e} -computeWorkers $COMPUTEWORKERS -startNode $STARTNODE -ebpf $HIT $INDEX/${k} $DATA/${j} > ${RESULT}/magazine_${COMPUTEWORKERS}_${e}.out
                sudo $APP_PATH/${e} -computeWorkers $COMPUTEWORKERS -startNode $STARTNODE -hit $HIT -queueDepth $qd -hitSize ${h} $INDEX/${k} $DATA/${j} 
                # >> ${RESULT}/bfs_hit_H${h}_D1.out
            done
        done
    done
done