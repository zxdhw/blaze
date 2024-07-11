#prarm
filename='bfs_hit2_sk2005'
runtime=30
frequency=1
device='/dev/nvme1n1'

iostat -m -d -x -t ${device} ${frequency} ${runtime} > ${filename}.out
# cat ${filename}.out | awk '/nvme/ {print $3}' > ${filename}.read_bw.log