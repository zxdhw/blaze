#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include "helpers.h"
#include "bfs_bpf/bfs_types.h"

#include <linux/bpf.h>
#include <linux/lirc.h>
#include <linux/input.h>
#include <bpf/bpf.h>
#include <bpf/libbpf.h>

int load_bpf_program(char *path) {
    struct bpf_object *obj;
    int ret, progfd;

    ret = bpf_prog_load(path, BPF_PROG_TYPE_XRP, &obj, &progfd);
    if (ret) {
        printf("Failed to load bpf program\n");
        exit(1);
    }

    return progfd;
}
