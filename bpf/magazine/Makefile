LLC ?= llc
CLANG ?= clang
CC ?= gcc
BPF_CFLAGS ?= -I$(LIBBPF_DIR)/build/usr/

magazine.o: magazine.c ../ebpf_types.h

%.o: %.c
	$(CLANG) -S \
	    -target bpf \
	    -D __BPF_TRACING__ \
	    $(BPF_CFLAGS) \
	    -Wall \
	    -Wno-pointer-sign \
	    -Wno-compare-distinct-pointer-types \
	    -O2 -emit-llvm -c -g -o ${@:.o=.ll} $<
	$(LLC) -march=bpf -filetype=obj -o $@ ${@:.o=.ll}


.PHONY: clean
clean: 
	rm -rf *.o *.ll


# CC = gcc
# CFLAGS = -Wall -D_GNU_SOURCE -Wunused
# LDLIBS = -pthread -lbpf -lm

# all: bfs_bpf.o 

# bfs_bpf.o: bfs_bpf.c bfs_types.h

# .PHONY: clean
# clean: 
# 	rm -rf *.o
