#prarm
io_filename='X2900P/io'
runtime=15
frequency=1
device='/dev/nvme2n1'

#path
APP_PATH='/home/zhengxd/blaze/build/bin'
INDEX='/home/zhengxd/dataset/mnt/nvme2/'
DATA='/home/zhengxd/dataset/mnt/nvme2/'

# parameter
COMPUTEWORKERS=2
STARTNODE=0
declare -a apps=("bfs" "bc")
# declare -a COMPUTEWORKERS=("8" "12" "16" "20" "24")
#data and index
declare -a index=("rmat27.gr.index")
declare -a data=("rmat27.gr.adj.0")
# declare -a index=("rmat27.gr.index" "uran27.gr.index")
# declare -a data=("rmat27.gr.adj.0" "uran27.gr.adj.0")
# declare -a index=("rmat30.gr.index")
# declare -a data=("rmat30.gr.adj.0")

iostat -m -d ${device} ${frequency} ${runtime} > ${io_filename}_${COMPUTEWORKERS}.out &
# for e in "${apps[@]}"; do
#   for ((i=0; i<${#index[@]}; i++)); do
#       k="${index[i]}"
#       j="${data[i]}"
#       sudo $APP_PATH/${e} -computeWorkers $COMPUTEWORKERS -startNode $STARTNODE $INDEX/${k} $DATA/${j} &
#   done
# done
sudo taskset -c 1,2,3 $APP_PATH/bfs -computeWorkers 2 -startNode 0 $INDEX/rmat27.gr.index $DATA/rmat27.gr.adj.0 &
sudo taskset -c 4,5,6 $APP_PATH/pagerank -computeWorkers 2 $INDEX/rmat27.gr.index $DATA/rmat27.gr.adj.0