#! /bin/bash
# VMLINUX='/boot/vmlinuz'

PERF_PARSED_LIST='/home/zxd/blaze/analysis/perf/'
PERF_PARSED_GRAPH='/home/zxd/blaze/analysis/perf/'
PERF_RES='/home/zxd/blaze/analysis/perf/'
APP_PATH='/home/zxd/blaze/build/bin'
DATA='/home/zxd/dataset//graph/sk2005.gr.adj.0'
INDEX='/home/zxd/dataset/graph/sk2005.gr.index'
VMLINUX='/home/zxd/linux-build/linux/vmlinux'

THREAD=10
CORE=$((THREAD + 1))
EBPF=1
STARTNODE=50395005
declare -a apps=("bfs")
# declare -a apps=("bfs" "bc" "pagerank" "wcc" "spmv")

# Run workloads

for e in "${apps[@]}"
do
# LOG_LEVEL="debug";
# perf record -g -e instructions -F 99 -o $PERF_RES/${e}.perf.out $APP_PATH/${e} -computeWorkers $THREAD -startNode $STARTNODE $INDEX $DATA;
sudo timeout 25s perf record -C $CORE -e instructions -F 99 -o $PERF_RES/${EBPF}_${e}.perf.out $APP_PATH/${e} -computeWorkers $THREAD -startNode $STARTNODE -ebpf $EBPF $INDEX $DATA;
# --call-graph dwarf
# perf record -C $CORE -g -e instructions -F 99 -o $PERF_RES/${EBPF}_${e}_g.perf.out $APP_PATH/${e} -computeWorkers $THREAD -startNode $STARTNODE -ebpf $EBPF $INDEX $DATA;
done

# parse
for e in "${apps[@]}"
do
sudo perf report -n -m --stdio --full-source-path --source -s symbol -i $PERF_RES/${EBPF}_${e}.perf.out > $PERF_PARSED_LIST/${EBPF}_perf_parsed_${e}.txt;
# perf report  -n -m --stdio --full-source-path --source -s symbol -i $PERF_RES/${e}.perf.out > $PERF_PARSED_LIST/perf_parsed_${e}.txt;
# --vmlinux $VMLINUX
# perf report  -n -m --stdio --full-source-path --source -s symbol --call-graph=graph,0,caller,function,count -i $PERF_RES/${EBPF}_${e}_g.perf.out > $PERF_PARSED_GRAPH/${EBPF}_perf_parsed_${e}_g.txt;
done