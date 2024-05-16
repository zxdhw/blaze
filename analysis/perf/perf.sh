#! /bin/bash

PERF_RES='./'
PERF_PARSED_LIST='./'
PERF_PARSED_GRAPH='./'
APP_PATH='/home/zxd/blaze/build/bin'
DATA='/home/zxd/dataset/graph/sk2005.gr.adj.0'
INDEX='/home/zxd/dataset/graph/sk2005.gr.index'
THREAD=10
STARTNODE=50395005
EBPF=1
declare -a apps=("bfs")
# declare -a apps=("bfs" "bc" "pagerank" "wcc" "spmv")

# Run workloads
for e in "${apps[@]}"
do
LOG_LEVEL="debug";
# perf record -g -e instructions -F 99 -o $PERF_RES/${e}.perf.out $APP_PATH/${e} -computeWorkers $THREAD -startNode $STARTNODE $INDEX $DATA;
# perf record -C 17 -e instructions -F 99 -o $PERF_RES/${e}.perf.out $APP_PATH/${e} -computeWorkers $THREAD -startNode $STARTNODE $INDEX $DATA;
sudo perf record --all-cpus -e instructions -F 99 -o $PERF_RES/${EBPF}_${e}_g.out $APP_PATH/${e} -computeWorkers $THREAD --startNode $STARTNODE -ebpf $EBPF $INDEX $DATA;
done

# parse
for e in "${apps[@]}"
do
# perf report --vmlinux $VMLINUX -n -m --stdio --full-source-path --source -s symbol -i $PERF_RES/${e}.perf.out >> $PERF_PARSED_LIST/perf_parsed_${e}.txt;
# perf report  -n -m --stdio --full-source-path --source -s symbol -i $PERF_RES/${e}.perf.out >> $PERF_PARSED_LIST/perf_parsed_${e}.txt;
sudo perf report  --cpu 11 -n --stdio --source -s symbol -i $PERF_RES/${EBPF}_${e}_g.out > $PERF_PARSED_GRAPH/${EBPF}_${THREAD}_${e}_g.txt;
# --call-graph=graph,0,caller,function,count
done