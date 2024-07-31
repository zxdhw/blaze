#prarm
# filename='bfs_rmat27-libaio-4k-nomerge'
filename='bfs_sk2005-hit16'
runtime=30
frequency=1
device='/dev/nvme1n1'

iostat -m -d ${device} ${frequency} ${runtime} > ${filename}.out
cat ${filename}.out | awk '/nvme/ {print $3}' > ${filename}.read_bw.log