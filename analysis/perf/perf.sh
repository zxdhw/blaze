#! /bin/bash
# VMLINUX='/boot/vmlinuz'

PERF_RES='./'
PERF_PARSED_LIST='./'
PERF_PARSED_GRAPH='./'
APP_PATH='/home/femu/blaze/build/bin'
DATA='/home/femu/dataset/rmat27.gr.adj.0'
INDEX='/home/femu/dataset/rmat27.gr.index'
THREAD=14
STARTNODE=0
declare -a apps=("bfs")
# declare -a apps=("bfs" "bc" "pagerank" "wcc" "spmv")

# Run workloads

for e in "${apps[@]}"
do
LOG_LEVEL="debug";
# perf record -g -e instructions -F 99 -o $PERF_RES/${e}.perf.out $APP_PATH/${e} -computeWorkers $THREAD -startNode $STARTNODE $INDEX $DATA;
# perf record -C 17 -e instructions -F 99 -o $PERF_RES/${e}.perf.out $APP_PATH/${e} -computeWorkers $THREAD -startNode $STARTNODE $INDEX $DATA;

perf record -C 15 -g -e instructions -F 99 -o $PERF_RES/${e}_g.perf.out $APP_PATH/${e} -computeWorkers $THREAD -startNode $STARTNODE $INDEX $DATA;
done

# parse
for e in "${apps[@]}"
do
# perf report --vmlinux $VMLINUX -n -m --stdio --full-source-path --source -s symbol -i $PERF_RES/${e}.perf.out >> $PERF_PARSED_LIST/perf_parsed_${e}.txt;
# perf report  -n -m --stdio --full-source-path --source -s symbol -i $PERF_RES/${e}.perf.out >> $PERF_PARSED_LIST/perf_parsed_${e}.txt;

perf report  -n -m --stdio --full-source-path --source -s symbol --call-graph=graph,0,caller,function,count -i $PERF_RES/${e}_g.perf.out >> $PERF_PARSED_GRAPH/perf_parsed_${e}_g.txt;
done