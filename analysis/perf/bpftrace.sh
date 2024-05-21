# #!/bin/bash

# APP_PATH='/home/zxd/blaze/build/bin'
# APP_NAME='bfs'
# CORE=11 
# INDEX='/home/zxd/dataset/graph/sk2005.gr.index'
# DATA='/home/zxd/dataset/graph/sk2005.gr.adj.0'
# STARTNODE=50395005
# EBPF=1

# # bpftrace script to trace function calls on a specific CPU core
# cat <<EOF > /tmp/trace_app.bt
# tracepoint:syscalls:sys_enter_execve /pid == @pid/ {
#     @start[tid] = nsecs;
# }

# tracepoint:syscalls:sys_exit_execve /pid == @pid/ {
#     @start[tid] = 0;
# }

# uprobe:/home/zxd/blaze/build/bin/${APP_NAME}:"*" /cpu == ${CORE}/ {
#     @count[func] = count();
#     printf("%d: %s\\n", tid, func);
# }
# EOF

# # Run the application with bpftrace monitoring
# sudo bpftrace -e 'BEGIN { @pid = pid(); }' /tmp/trace_app.bt &
# BPFTRACE_PID=$!

# sudo timeout 25s $APP_PATH/${APP_NAME} -computeWorkers 10 -startNode $STARTNODE -ebpf $EBPF $INDEX $DATA

# # Kill bpftrace after the application finishes
# sudo kill -INT $BPFTRACE_PID

#!/bin/bash

APP_PATH='/home/zxd/blaze/build/bin'
APP_NAME='bfs'
CORE=11 
INDEX='/home/zxd/dataset/graph/sk2005.gr.index'
DATA='/home/zxd/dataset/graph/sk2005.gr.adj.0'
STARTNODE=50395005
EBPF=1

# Run the application and get its PID
sudo timeout 20s $APP_PATH/${APP_NAME} -computeWorkers 11 -startNode $STARTNODE -ebpf $EBPF $INDEX $DATA &
APP_PID=$!
sleep 1 # Ensure the application has started

# bpftrace script to trace function calls on a specific CPU core
cat <<EOF > /tmp/trace_app.bt
uprobe:/home/zxd/blaze/build/bin/${APP_NAME}: submitTasks_dense_ebpf /pid == ${APP_PID} && cpu == ${CORE}/ {
    @count[func] = count();
    printf("%d: %s\n", tid, func);
}
EOF

# Run bpftrace with the created script
sudo bpftrace /tmp/trace_app.bt &

# Wait for the application to finish
wait $APP_PID
