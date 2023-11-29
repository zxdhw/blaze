CC = gcc
CFLAGS = -Wall -D_GNU_SOURCE -Wunused
LDLIBS = -pthread -lbpf -lm


all: bpf

helpers.o: helpers.c helpers.h bfs/bfs_types.h

bfs.o : bfs.c bfs.h bfs/bfs_types.h  helpers.h

.PHONY: bpf
bpf:
	make -C bfs_bpf -f Makefile

.PHONY: clean
clean:
	make -C bfs_bpf -f Makefile clean
