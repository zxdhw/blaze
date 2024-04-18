#ifndef EBPF_TYPES_H
#define EBPF_TYPES_H


// #define assert(condition, message) { 
//     if(!condition) {} 
// }
// Data-level information

typedef unsigned long ptr__m;
typedef unsigned long pageid_m;
typedef unsigned long length_m; //以page为单位
typedef unsigned long offset_m; //以page为单位


#define BLK_SIZE_SSD 4096
#define SCRATCH_SIZE 4096   // 4KB
#define IO_INFO  150        // 最大可以寄生的IO数量
#define MAX_BIO_SIZE 128 * 1024       // 单次IO（包括寄生）的最大大小 128KB 
#define IO_MAX_PAGES_PER_MG 32
#define PTR_SIZE sizeof(ptr__t)


/* MASK to prevent out of bounds memory access*/
#define BLOCK_OFFSET_MASK SCRATCH_SIZE
#define INFTY_64 vertex_t(1<<63) //将默认值设为INFTY_64


// Node offset "encoding"
#define FILE_MASK ((ptr__m)1 << 63)

/*struct used to communicate with BPF function via scratch buffer */
typedef struct _Scratch {

    pageid_m    spage[IO_INFO];  // 起始pageid
    offset_m    offset[IO_INFO]; // 4KB对齐
    length_m    length[IO_INFO]; // 以4KB为单位

    length_m    buffer_offset;   // buffer偏移，以字节为单位
    length_m    buffer_len;      // buffer最大长度
    length_m    max_index;       // 最大索引；
    length_m    curr_index;      // 当前索引 0
    length_m    scartch;         // 0 不使用scratch，其余使用。
    length_m    unused[57];
}Scratch;

// _Static_assert (sizeof(Scratch) == SCRATCH_SIZE, "struct too large for scratch page");

// #ifdef VERBOSE
// #define dbg_print(...) bpf_printk(__VA_ARGS__)
// #else
// #define dbg_print(...)
// #endif //VERBOSE


#define dbg_print(...) bpf_printk(__VA_ARGS__)



#endif /* EBPF_TYPES_H */
