#!/bin/bash

# 图计算系统： 
# Blaze: Fast Graph Processing for Fast SSDs. （SC‘22） https://github.com/NVSL/blaze 
# The state-of-the-art graph processing system in terms of throughput

# 数据集及算法
# 数据集： rmat27; 大小：13GB; 顶点数：134M
# 算法：一次BFS查询

# SSD: samsung PM1743

# libaio arg
depth=("128")

# hitchhike arg
MergeDegree=("8")

# enable hitchhike ?
enable_hitchhike=1

# common arg
apps=("bfs")
index=("rmat27.gr.index")
data=("rmat27.gr.adj.0")

# parameter
COMPUTEWORKERS=16
STARTNODE=0
APP_PATH=/home/zhengxd/blaze/build/bin
INDEX=/home/zhengxd/dataset/mnt/samsung5/
DATA=/home/zhengxd/dataset/mnt/samsung5/

#libaio test
sudo $APP_PATH/$apps -computeWorkers $COMPUTEWORKERS -startNode $STARTNODE -hit $enable_hitchhike -queueDepth $depth -hitSize $MergeDegree $INDEX/$index $DATA/$data
