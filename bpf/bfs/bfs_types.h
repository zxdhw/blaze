#ifndef BFS_TYPES_H
#define BFS_TYPES_H


// #define assert(condition, message) { 
//     if(!condition) {} 
// }
// Data-level information

typedef unsigned long ptr__t;
typedef unsigned int vertex_t;
typedef unsigned long offset_t;
typedef unsigned int length_t;

#define ADJ_SIZE sizeof(Adj_info)
#define BLK_SIZE_SSD 4096
#define SCRATCH_SIZE 4096 // 4KB或许有点小 ：64KB？
#define IO_INFO  250   //记录已经遍历过的vertex
#define PTR_SIZE sizeof(ptr__t)


/* MASK to prevent out of bounds memory access*/
#define BLOCK_OFFSET_MASK SCRATCH_SIZE
#define INFTY_64 vertex_t(1<<63) //将默认值设为INFTY_64

/*init vertex info*/
#define ROOT_VERTEX_OFFSET 0
#define ROOT_VERTEX 0

// Node offset "encoding"
#define FILE_MASK ((ptr__t)1 << 63)

typedef struct _io_info {
    offset_t offset[IO_INFO];
    length_t length[IO_INFO];
    vertex_t vertex[IO_INFO];
    length_t current_len;
    length_t current_vertex;
}io_info;

/*BFS:: struct used to communicate with BPF function via scratch buffer */
typedef struct _BFS {
    /* io info: (250* 16 + 8)B*/
    /*record which vertex need to traverse (active state)*/
    io_info traversed;

    /* everything is a long to make debugging in gdb easier */
    /* traversed info*/
    /* init info: (4+4+8+4)B = 20B */
    unsigned int  start_vertex;
    unsigned int degree;
    unsigned long offset;
    unsigned int unused[18];
    
}BFS;

_Static_assert (sizeof(BFS) == SCRATCH_SIZE, "struct Query too large for scratch page");

static inline BFS new_bfs() {
    BFS bfs = {
        .start_vertex = { 0 },
        .degree = {0},
        .offset = {0},
        .traversed = { 0 },
    };
    return bfs;
}

// #ifdef VERBOSE
// #define dbg_print(...) bpf_printk(__VA_ARGS__)
// #else
// #define dbg_print(...)
// #endif //VERBOSE


#define dbg_print(...) bpf_printk(__VA_ARGS__)



#endif /* BFS_TYPES_H */
