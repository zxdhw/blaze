#ifndef hit_HELPERS_H
#define hit_HELPERS_H

#include <errno.h>
#include <linux/aio_abi.h>
#include <stdlib.h>
#include <stdio.h>
#include <alloca.h>
#include <stdint.h>
#include <math.h>
#include <stdbool.h>
#include <unistd.h>
#include <string.h>
#include <linux/lirc.h>
#include <linux/input.h>
#include "hit_types.h"

struct hitchhiker;
#define HIT_NUMBER HIT_MAX

namespace blaze {
// struct hit_stats {

// 	long io_time;
// 	long io_count;

// 	long aio_time;
// 	long aio_count;

// 	long aio_hit_time;
// 	long aio_hit_count;

// 	long read_iter_time;
// 	long read_iter_count;

// 	long file_read_iter_time;
// 	long file_read_iter_count;

// 	long fs_time;
// 	long fs_count;

// 	long submit_bio_time;
// 	long submit_bio_count;

// 	long block_time;
// 	long block_count;

// 	long bio_submit_time;
// 	long bio_submit_count;

// 	long driver_time;
// 	long driver_count;

// 	long queue_rq_time;
// 	long queue_rq_count;

// 	long verify_time;
// 	long verify_count;

// 	long dio_time;
// 	long dio_count;

// 	long filemap_wait_time;
// 	long filemap_wait_count;

// 	long iomap_time;
// 	long iomap_count;

// 	long iomap_hit_time;
// 	long iomap_hit_count;

// 	long get_page_time;
// 	long get_page_count;

// 	long bio_time;
// 	long bio_count;

// 	long hit_buf_time;
// 	long hit_buf_count;

// 	long req_time;
// 	long req_count;

// 	long dma_time;
// 	long dma_count;

// 	long hit_cmd_time;
// 	long hit_cmd_count;

// 	long sq_time;
// 	long sq_count;

// 	long cmd_time;
// 	long cmd_count;

// 	long dma_unmap_time;
// 	long dma_unmap_count;

// 	long interrupt_time;
// 	long interrupt_count;

// };
struct hit_stats {
	//ktime
	long ktime_time;
	long ktime_count;

	// aio stat
	long io_time_kernel;
	long io_count_kernel;

	long aio_time;
	long aio_count;

	long aio_hit_time;
	long aio_hit_count;

	long get_user_time;
	long get_user_count;

	long copy_user_time;
	long copy_user_count;

	long aio_req_time;
	long aio_req_count;

	long aio_fget_time;
	long aio_fget_count;

	long aio_prep_time;
	long aio_prep_count;

	long aio_setup_time;
	long aio_setup_count;

	long verify_time;
	long verify_count;

	long read_iter_time;
	long read_iter_count;

	// fs stat
	long file_read_iter_time;
	long file_read_iter_count;

	long fs_time;
	long fs_count;

	long dio_time;
	long dio_count;

	long filemap_wait_time;
	long filemap_wait_count;

	long iomap_time;
	long iomap_count;

	long iomap_hit_time;
	long iomap_hit_count;

	long get_page_time;
	long get_page_count;

	long bio_time;
	long bio_count;

	long hit_buf_time;
	long hit_buf_count;

	long plug_time;
	long plug_count;

	// block stat
	long fs_submit_time;
	long fs_submit_count;

	long block_time;
	long block_count;

	long submit_bio_time;
	long submit_bio_count;

	long hit_tag_time;
	long hit_tag_count;

	long req_time;
	long req_count;

	//driver
	long driver_time;
	long driver_count;

	long queue_rq_time;
	long queue_rq_count;

	long dma_time;
	long dma_count;

	long hit_cmd_time;
	long hit_cmd_count;

	long sq_time;
	long sq_count;

	long cmd_time;
	long cmd_count;

	long dma_unmap_time;
	long dma_unmap_count;

	long interrupt_time;
	long interrupt_count;

};

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
