/*
 * BPF program for BFS
 *
 * Author: zhengxd
 */
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <stdbool.h>
#include "ebpf_types.h"

char LICENSE[] SEC("license") = "GPL";
// #define PAGE_SIZE 4096

/* read csr info， put into active queue
 * @param csr: data
 * @param bfs: metadata
 */
static __inline void set_next_block(Scratch *mg, struct bpf_xrp *context){
    dbg_print("-------set_next_block enter----\n");

    if (!mg) return;
    // if(mg->curr_index < 0 || mg->max_index >= IO_INFO) return;

    if(mg->scratch && mg->curr_index < IO_INFO && mg->curr_index <= mg->max_index){

        /*set next io*/
        context->next_addr[0] = mg->offset[mg->curr_index & INDEX_MASK];
        dbg_print("-------next_addr is %lld----\n",context->next_addr[0]);
        if(mg->length[mg->curr_index & INDEX_MASK] > PAGE_MAX) return;
        // unsigned long long length = mg->length[mg->curr_index] * PAGE_SIZE;
        context->size[0] = mg->length[mg->curr_index & INDEX_MASK] * PAGE_SIZE;
        mg->curr_index++;
        // mg->buffer_offset += mg->length[mg->curr_index];
        // if(mg->buffer_offset > mg->buffer_len){
        //     context->done = 1;
        //     // context->next_addr[0] = 0;
        //     // context->size[0] = 0;
        //     return;
        // }
        
    } else {
        /* finish bfs_bpf*/
        context->done = 1;
        // context->next_addr[0] = 0;
        // context->size[0] = 0;
        return;
    } 
    return;
}

SEC("haslab_bfs")
unsigned int haslab_bfs_func(struct bpf_xrp *context) {
    //page信息转换
    dbg_print("bfs-bpf: entered\n");
    Scratch *magazine = (Scratch *) context->scratch;
    
    set_next_block(magazine,context);
    
    return 0;
}