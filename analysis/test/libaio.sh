#!/bin/bash


#path
APP_PATH=/home/zhengxd/blaze/build/bin
INDEX=/home/zhengxd/dataset/mnt/samsung5/
DATA=/home/zhengxd/dataset/mnt/samsung5/

# parameter
COMPUTEWORKERS=16
STARTNODE=0

# libaio arg
declare -a depth=("128")
#hit arg
declare -a hitSize=("8")

# common arg
declare -a apps=("bfs")
declare -a index=("rmat27.gr.index")
declare -a data=("rmat27.gr.adj.0")
HIT=0

#libaio test

for h in "${hitSize[@]}"; do
    for e in "${apps[@]}"; do
        for qd in "${depth[@]}"; do
            for ((i=0; i<${#index[@]}; i++)); do
                k="${index[i]}"
                j="${data[i]}"
                sudo $APP_PATH/${e} -computeWorkers $COMPUTEWORKERS -startNode $STARTNODE -hit $HIT -queueDepth $qd -hitSize ${h} $INDEX/${k} $DATA/${j} > libaio.out
            done
        done
    done
done