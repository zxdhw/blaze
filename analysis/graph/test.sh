#!/bin/bash
# sudo ~/blaze/build/bin/bfs -computeWorkers 16 -startNode 0 /home/zhengxd/mnt/nvme/sc22/rmat27.gr.index /home/zhengxd/mnt/nvme/sc22/rmat27.gr.adj.0 
# sudo ~/blaze/build/bin/bfs -computeWorkers 8 -startNode 0 /home/zhengxd/mnt/nvme1/sc22/rmat27.gr.index /home/zhengxd/mnt/nvme1/sc22/rmat27.gr.adj.0  
# sudo ~/blaze/build/bin/bfs -computeWorkers 16 -startNode 12 /home/zhengxd/mnt/nvme/sc22/twitter.gr.index /home/zhengxd/mnt/nvme/sc22/twitter.gr.adj.0  
# sudo ~/blaze/build/bin/bfs -computeWorkers 16 -startNode 50395005 /home/zhengxd/mnt/nvme/sc22/sk2005.gr.index /home/zhengxd/mnt/nvme/sc22/sk2005.gr.adj.0 
# sudo ~/blaze/build/bin/bfs -computeWorkers 16 -startNode 0 /home/zhengxd/mnt/nvme/sc22/uran27.gr.index /home/zhengxd/mnt/nvme/sc22/uran27.gr.adj.0 
# sudo ~/blaze/build/bin/bfs -computeWorkers 16 -startNode 0 /home/zhengxd/mnt/nvme2/sc22/rmat27.gr.index /home/zhengxd/mnt/nvme2/sc22/rmat27.gr.adj.0 
# sudo ~/blaze/build/bin/bfs -computeWorkers 16 -startNode 101 /home/zhengxd/mnt/nvme1/sc22/friendster.gr.index /home/zhengxd/mnt/nvme1/sc22/friendster.gr.adj.0 


#path
APP_PATH='/home/zxd/blaze/build/bin'
# APP_PATH='/home/femu/blaze-old/blaze/build/bin'
INDEX='/home/zxd/dataset/graph'
DATA='/home/zxd/dataset/graph'
RESULT='/home/zxd/blaze/analysis/graph/dapuH'

# parameter
COMPUTEWORKERS=10
STARTNODE=50395005
# 101
EBPF=1
TIMES=1
declare -a apps=("bfs")
#data and index
declare -a index=("sk2005.gr.index")
declare -a data=("sk2005.gr.adj.0")
# declare -a index=("rmat27.gr.index")
# declare -a data=("rmat27.gr.adj.0")
#"rmat27.gr.index" "rmat30.gr.index" "uran27.gr.index" 
# declare -a apps=("bfs" "bc" "pagerank" "wcc" "spmv")
# for ((n=0; n<TIMES; n++)); do
#     for e in "${apps[@]}"; do
#         for ((i=0; i<${#index[@]}; i++)); do
#             k="${index[i]}"
#             j="${data[i]}"
#             sudo $APP_PATH/${e} -computeWorkers $COMPUTEWORKERS -startNode $STARTNODE -ebpf $EBPF $INDEX/${k} $DATA/${j} > ${RESULT}/magazine_${COMPUTEWORKERS}_${e}.out
#             # sudo $APP_PATH/${e} -computeWorkers $COMPUTEWORKERS -startNode $STARTNODE $INDEX/${k} $DATA/${j} >> nromal.out
#         done
#     done
# done

for ((n=0; n<TIMES; n++)); do
    for e in "${apps[@]}"; do
        for ((i=0; i<${#index[@]}; i++)); do
            k="${index[i]}"
            j="${data[i]}"
            # sudo $APP_PATH/${e} -computeWorkers $COMPUTEWORKERS -startNode $STARTNODE -ebpf $EBPF $INDEX/${k} $DATA/${j} > ${RESULT}/magazine_${COMPUTEWORKERS}_${e}.out
            sudo $APP_PATH/${e} -computeWorkers $COMPUTEWORKERS -startNode $STARTNODE -ebpf $EBPF $INDEX/${k} $DATA/${j} > batch.out
        done
    done
done