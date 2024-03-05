#! /bin/bash

APP_PATH='/home/zhengxd/blaze/build/bin'
DATA='/home/zhengxd/dataset/mnt/nvme1/rmat27.gr.adj.0'
INDEX='/home/zhengxd/dataset/mnt/nvme1/rmat27.gr.index'
THREAD=15
STARTNODE=0
declare -a apps=("bfs")
# declare -a apps=("bfs" "bc" "pagerank" "wcc" "spmv")

# Run workloads

for e in "${apps[@]}"; do
    $APP_PATH/${e} -computeWorkers $THREAD -startNode $STARTNODE $INDEX $DATA > libaio_${e}.out
done