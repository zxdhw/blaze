#ifndef hit_HELPERS_H
#define hit_HELPERS_H

#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <alloca.h>
#include <stdint.h>
#include <math.h>
#include <stdbool.h>
#include <unistd.h>
#include <string.h>
#include <linux/bpf.h>
#include <linux/lirc.h>
#include <linux/input.h>
#include <bpf/bpf.h>
#include <bpf/libbpf.h>
#include "hit_types.h"


namespace blaze {

typedef struct hitchhike magazine;


struct hit_stats {

	long aio_time;
	long aio_count;

	long aio_hit_time;
	long aio_hit_count;
    
	long read_iter_time;
	long read_iter_count;

	long fs_time;
	long fs_count;

	long block_time;
	long block_count;

	long driver_time;
	long driver_count;

	long iomap_time;
	long iomap_count;

	long get_page_time;
	long get_page_count;

    long bio_time;
	long bio_count;

	long req_time;
	long req_count;

    long dma_time;
	long dma_count;

    long sq_time;
	long sq_count;

    long sq_cpy_time;
	long sq_cpy_count;

    long sq_write_time;
	long sq_write_count;

    long lock_time;
	long lock_count;

	long interrupt_time;
	long interrupt_count;
};

static int load_bpf_program(const char *path) {
    struct bpf_object *obj;
    int ret, progfd;

    ret = bpf_prog_load(path, BPF_PROG_TYPE_XRP, &obj, &progfd);
    if (ret) {
        printf("Failed to load bpf program\n");
        exit(1);
    }

    return progfd;
}

static void dump_page(uint8_t *page_image, uint64_t size) {
    int row, column, addr;
    uint64_t page_offset = 0;
    printf("=============================PAGE DUMP START=============================\n");
    for (row = 0; row < size / 16; ++row) {
        printf("%08lx  ", page_offset + 16 * row);
        for (column = 0; column < 16; ++column) {
            addr = 16 * row + column;
            printf("%02x ", page_image[addr]);
            if (column == 7 || column == 15) {
                printf( " ");
            }
        }
        printf("|");
        for (column = 0; column < 16; ++column) {
            addr = 16 * row + column;
            if (page_image[addr] >= '!' && page_image[addr] <= '~') {
                printf( "%c", page_image[addr]);
            } else {
                printf( ".");
            }
        }
        printf("|\n");
    }
    printf("==============================PAGE DUMP END==============================\n");
}


}// namespace blaze

#endif //hit_HELPERS_H
