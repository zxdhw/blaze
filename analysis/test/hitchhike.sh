#!/bin/bash

#path
APP_PATH=/home/zhengxd/blaze/build/bin
INDEX=/home/zhengxd/dataset/mnt/samsung5/
DATA=/home/zhengxd/dataset/mnt/samsung5/

# parameter
COMPUTEWORKERS=16
HIT=1

STARTNODE=0
# libaio arg
declare -a depth=("8")
#hit arg
declare -a hitSize=("64")


# common arg
declare -a apps=("bfs")
declare -a index=("rmat27.gr.index")
declare -a data=("rmat27.gr.adj.0")


for h in "${hitSize[@]}"; do
    for e in "${apps[@]}"; do
        for qd in "${depth[@]}"; do
            for ((i=0; i<${#index[@]}; i++)); do
                k="${index[i]}"
                j="${data[i]}"
                sudo $APP_PATH/${e} -computeWorkers $COMPUTEWORKERS -startNode $STARTNODE -hit $HIT -queueDepth $qd -hitSize ${h} $INDEX/${k} $DATA/${j} > hitchhike.out
            done
        done
    done
done
