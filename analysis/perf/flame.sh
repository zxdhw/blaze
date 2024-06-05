#! /bin/bash

PERF_PARSED_LIST='/home/zxd/blaze/analysis/perf/'
PERF_PARSED_GRAPH='/home/zxd/blaze/analysis/perf/'
PERF_RES='/home/zxd/blaze/analysis/perf/'


perf script --cpu 11 -i $PERF_RES/1_bfs.out > perf.script

./stackcollapse-perf.pl perf.script | ./flamegraph.pl > worklet-sq-32.svg