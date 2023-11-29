/*
 * BPF program for BFS
 *
 * Author: xuda zheng
 */
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <stdbool.h>
#include "bfs_types.h"

char LICENSE[] SEC("license") = "GPL";


/* read csr info， put into active queue
 * @param csr: data
 * @param bfs: metadata
 */
static __inline void set_next_block(CSR *csr, BFS *bfs, struct bpf_xrp *context){


    if( bfs->traversed.current_vertex < IO_INFO){
        /* 设置下一个I/O
        */
        context->next_addr[0] = bfs->traversed.offset[bfs->traversed.current_vertex];
        /*更新统计信息
        */
        bfs->traversed.current_vertex++;
        bfs->traversed.current_len += bfs->traversed.length[bfs->traversed.current_vertex];
     
    } else {
        /* finish bfs_bpf*/
        context->done = 1;
        context->next_addr[0] = 0;
        context->size[0] = 0;
        return;
    }
    
    return;
}

SEC("haslab_bfs")
unsigned int haslab_bfs_func(struct bpf_xrp *context) {
    //page信息转换
    dbg_print("bfs-bpf: entered\n");
    BFS *bfs = (BFS *) context->scratch;
    
    set_next_block(bfs,context);
    
    return 0;
}