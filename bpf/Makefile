CC = gcc
CFLAGS = -Wall -D_GNU_SOURCE -Wunused
LDLIBS = -pthread -lbpf -lm


all: bpf

helpers.o: helpers.c helpers.h ebpf_types.h

magazine.o : magazine.c  ebpf_types.h  helpers.h

.PHONY: bpf
bpf:
	make -C magazine -f Makefile

.PHONY: clean
clean:
	make -C magazine -f Makefile clean
