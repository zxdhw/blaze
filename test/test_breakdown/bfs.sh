#! /bin/bash

APP_PATH='/home/zhengxd/blaze/build/bin'
DATA='/home/zhengxd/dataset/mnt/nvme2/rmat27.gr.adj.0'
INDEX='/home/zhengxd/dataset/mnt/nvme2/rmat27.gr.index'
THREAD=16
STARTNODE=0
declare -a apps=("bfs")
# declare -a apps=("bfs" "bc" "pagerank" "wcc" "spmv")

# Run workloads

for e in "${apps[@]}"
do
$APP_PATH/${e} -computeWorkers $THREAD -startNode $STARTNODE $INDEX $DATA;
done

