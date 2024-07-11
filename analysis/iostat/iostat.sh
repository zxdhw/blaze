#prarm
filename='bfs_rmat27_uran27'
runtime=15
frequency=1
device='/dev/nvme1n1'

iostat -m -d ${device} ${frequency} ${runtime} > ${filename}.out
cat ${filename}.out | awk '/nvme/ {print $3}' > ${filename}.read_bw.log