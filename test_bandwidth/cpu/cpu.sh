#prarm
cpu_filename='data/mutli/X2900P/cpu_output'
io_filename='data/mutli/X2900P/io_output'
runtime=100
frequency=1
device='/dev/nvme2n1'

sar -P 1-16 ${frequency}  ${runtime}  > ${cpu_filename}.out &
iostat -m -d ${device} ${frequency} ${runtime}  > ${io_filename}.out &

#path
APP_PATH='/home/zhengxd/blaze/build/bin'
INDEX='/home/zhengxd/dataset/mnt/nvme2/'
DATA='/home/zhengxd/dataset/mnt/nvme2/'

# parameter
COMPUTEWORKERS=16
STARTNODE=0
declare -a apps=("bfs")
#data and index
declare -a index=("rmat27.gr.index" "uran27.gr.index" "rmat27.gr.index" "uran27.gr.index")
declare -a data=("rmat27.gr.adj.0" "uran27.gr.adj.0" "rmat27.gr.adj.0" "uran27.gr.adj.0")
# declare -a index=("rmat30.gr.index")
# declare -a data=("rmat30.gr.adj.0")

for e in "${apps[@]}"; do
    for ((i=0; i<${#index[@]}; i++)); do
        k="${index[i]}"
        j="${data[i]}"
        sudo $APP_PATH/${e} -computeWorkers $COMPUTEWORKERS -startNode $STARTNODE $INDEX/${k} $DATA/${j} 
    done
done

# sleep 5
killall sar
killall iostat 

# sudo /home/zhengxd/blaze/build/bin/bfs -computeWorkers 16 -startNode 0 /home/zhengxd/dataset/mnt/nvme2/rmat27.gr.index /home/zhengxd/dataset/mnt/nvme2/rmat27.gr.adj.0 &

cat ${cpu_filename}.out | awk '/15时/ {print $8}' > ${cpu_filename}.idle.out
awk '
  BEGIN {
    sum = 0
    count = 0
  }
  /^%idle$/ {
    if (count > 0) {
      average = 100-(sum / count)
      print "Average %util:", average > "${cpu_filename}.util.out"
    }
    sum = 0
    count = s
    next
  }
  NF == 1 {
    sum += $1
    count += 1
  }
  END {
    if (count > 0) {
      average = 100-(sum / count)
      print "Average %util:", average > "${cpu_filename}.util.out"
    }
  }
' ${cpu_filename}.idle.out

cat ${io_filename}.out | awk '/nvme/ {print $3}' > ${io_filename}.bw.out