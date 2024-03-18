
io_filename='X2900P/io_16'
cat ${io_filename}.out | awk '/nvme/ {print $3}' > ${io_filename}.bw.out