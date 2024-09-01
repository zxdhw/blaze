#!/usr/bin/env bash

result_dir=result-test
disks=/home/zhengxd/dataset/mnt/samsung5
threads=16
# declare -a depth=("1" "16" "32" "64" "128" "256" "512" "1024")
declare -a depth=("256")
# declare -a depth=("1" "2" "4" "8" "16" "32" "64" "128" "256" "512" "1024")
# declare -a hitqueue=("8" "16" "32" "48" "64" "96" "127")
declare -a hitqueue=("96")
# depth=128
# hitSize=64
hitchhike=0
# Run workloads

for hitSize in "${hitqueue[@]}"; do
    for qd in "${depth[@]}"; do
        # BFS
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k bfs -d rmat27 --start_node 0
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k bfs -d uran27 --start_node 0
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k bfs -d twitter --start_node 12
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k bfs -d sk2005 --start_node 50395005
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k bfs -d friendster --start_node 101
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k bfs -d rmat30 --start_node 0

        # PageRank 
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k pagerank -d rmat27
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k pagerank -d uran27
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k pagerank -d twitter
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k pagerank -d sk2005
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k pagerank -d friendster
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k pagerank -d rmat30

        # # # WCC
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k wcc -d rmat27
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k wcc -d uran27
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k wcc -d twitter
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k wcc -d sk2005
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k wcc -d friendster
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k wcc -d rmat30

        # # # BC
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k bc -d rmat27 --start_node 0
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k bc -d uran27 --start_node 0
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k bc -d twitter --start_node 12
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k bc -d sk2005 --start_node 50395005
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k bc -d friendster --start_node 101
        ./run.py --result_dir ${result_dir} --disks ${disks} --hit ${hitchhike} --queueDepth ${qd} --hitSize ${hitSize} -t ${threads} -k bc -d rmat30 --start_node 0

    done
done