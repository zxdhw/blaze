#! /bin/bash

PERF_PARSED_LIST='/home/zxd/blaze/analysis/perf'
PERF_PARSED_GRAPH='/home/zxd/blaze/analysis/perf'
PERF_RES='/home/zxd/blaze/analysis/perf'
APP_PATH='/home/zxd/blaze/build/bin'
DATA='/home/zxd/dataset/graph/sk2005.gr.adj.0'
INDEX='/home/zxd/dataset/graph/sk2005.gr.index'
VMLINUX='/home/zxd/linux-build/linux/vmlinux'

THREAD=10
CORE=$((THREAD + 1))
EBPF=1
STARTNODE=50395005
declare -a apps=('bfs')

# Run workloads
for e in "${apps[@]}"
do
LOG_LEVEL="debug";
# sudo $APP_PATH/${e} -computeWorkers $THREAD -startNode $STARTNODE -ebpf $EBPF $INDEX $DATA;
# timeout 25s;  -C $CORE; -g;
sudo perf record --all-cpus -g -e instructions -F 99 -o $PERF_RES/${EBPF}_${e}.out $APP_PATH/${e} -computeWorkers $THREAD -startNode $STARTNODE -ebpf $EBPF $INDEX $DATA;
# timeout 25s;  -C $CORE; -g;
done

# parse
for e in "${apps[@]}"
do
sudo perf report --cpu $CORE -n --stdio -s symbol -i $PERF_RES/${EBPF}_${e}.out  > $PERF_PARSED_LIST/${EBPF}_${THREAD}_${e}_magazine.txt;
# sudo perf report --cpu 11 --call-graph=graph,0,caller,function,count --show-cpu-utilization -n --stdio -s symbol -i $PERF_RES/${EBPF}_${e}.out  > $PERF_PARSED_LIST/${EBPF}_${THREAD}_${e}_graph.txt;
# --call-graph=graph,0,caller,function,count
# --vmlinux 
# --show-cpu-utilization
done

