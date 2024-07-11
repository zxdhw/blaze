#!/bin/bash

# while true; do
#     cat /proc/diskstats >> disk.out
#     sleep 0.001
# done

cat disk.out | awk '/nvme1n1/ {print $12}' > hit7.read_qd.log