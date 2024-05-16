#ifndef EBPF_HELPERS_H
#define EBPF_HELPERS_H

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
#include "ebpf_types.h"


namespace blaze {

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

#endif //EBPF_HELPERS_H
