#ifndef HELPERS_H
#define HELPERS_H

#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <alloca.h>
#include <stdint.h>
#include <math.h>
#include <stdbool.h>
#include "bfs_bpf/bfs_types.h"

#define BLK_SIZE 4096
// #define BLK_SIZE 8192
#define SYS_READ_XRP 445

int load_bpf_program(char *path);


#endif //HELPERS_H
