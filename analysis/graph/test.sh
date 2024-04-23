#!/bin/bash
# sudo ~/blaze/build/bin/bfs -computeWorkers 16 -startNode 0 /home/zhengxd/mnt/nvme/sc22/rmat27.gr.index /home/zhengxd/mnt/nvme/sc22/rmat27.gr.adj.0 
# sudo ~/blaze/build/bin/bfs -computeWorkers 8 -startNode 0 /home/zhengxd/mnt/nvme1/sc22/rmat27.gr.index /home/zhengxd/mnt/nvme1/sc22/rmat27.gr.adj.0  
# sudo ~/blaze/build/bin/bfs -computeWorkers 16 -startNode 12 /home/zhengxd/mnt/nvme/sc22/twitter.gr.index /home/zhengxd/mnt/nvme/sc22/twitter.gr.adj.0  
# sudo ~/blaze/build/bin/bfs -computeWorkers 16 -startNode 50395005 /home/zhengxd/mnt/nvme/sc22/sk2005.gr.index /home/zhengxd/mnt/nvme/sc22/sk2005.gr.adj.0 
# sudo ~/blaze/build/bin/bfs -computeWorkers 16 -startNode 0 /home/zhengxd/mnt/nvme/sc22/uran27.gr.index /home/zhengxd/mnt/nvme/sc22/uran27.gr.adj.0 

# sudo ~/blaze/build/bin/bfs -computeWorkers 16 -startNode 0 /home/zhengxd/mnt/nvme2/sc22/rmat27.gr.index /home/zhengxd/mnt/nvme2/sc22/rmat27.gr.adj.0 
# sudo ~/blaze/build/bin/bfs -computeWorkers 16 -startNode 101 /home/zhengxd/mnt/nvme1/sc22/friendster.gr.index /home/zhengxd/mnt/nvme1/sc22/friendster.gr.adj.0 


#path
APP_PATH='/home/femu/blaze/build/bin'
INDEX='/home/femu/dataset/'
DATA='/home/femu/dataset/'

# parameter
COMPUTEWORKERS=14
STARTNODE=0
EBPF=1
declare -a apps=("bfs")
#data and index
declare -a index=("sk2005.gr.index")
declare -a data=("sk2005.gr.adj.0")
# declare -a index=("rmat27.gr.index")
# declare -a data=("rmat27.gr.adj.0")
#"rmat27.gr.index" "rmat30.gr.index" "uran27.gr.index" 
# declare -a apps=("bfs" "bc" "pagerank" "wcc" "spmv")

for e in "${apps[@]}"; do
    for ((i=0; i<${#index[@]}; i++)); do
        k="${index[i]}"
        j="${data[i]}"
        sudo $APP_PATH/${e} -computeWorkers $COMPUTEWORKERS -startNode $STARTNODE -ebpf $EBPF $INDEX/${k} $DATA/${j} 
    done
done
