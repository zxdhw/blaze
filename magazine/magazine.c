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

/* read scratch info
 * @param mg: scratch
 * @param contex: ebpf info
 */
static __inline void set_next_block(Scratch *mg, struct bpf_xrp *context){
    dbg_print("-------set_next_block enter----\n");
    // if(mg->curr_index < 0 || mg->max_index >= IO_INFO) return;

    if(mg->scratch && mg->curr_index < IO_INFO && mg->curr_index <= mg->max_index){

        /*set next io*/
        context->next_addr[0] = mg->offset[mg->curr_index & INDEX_MASK];
        dbg_print("-------next_addr is %lld, pid is %d----\n",context->next_addr[0], mg->spage[mg->curr_index & INDEX_MASK]);
        dbg_print("-------index_mask is %d----\n", INDEX_MASK);
        if(mg->length[mg->curr_index & INDEX_MASK] > PAGE_MAX) return;
        context->size[0] = mg->length[mg->curr_index & INDEX_MASK] * PAGE_SIZE;
        
        if(mg->curr_index > 0){
            mg->complete += mg->length[ (mg->curr_index -1) & INDEX_MASK] * PAGE_SIZE;
        }
        context->size[1] = mg->complete;
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