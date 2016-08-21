
# Makefile
# dark_neo
# 2014-08-22

ASCOM 		= as
LDCOM		= ld
OBJCOM		= objcopy
GZIPCOM		= gzip
OUTDIR		= out
KERNEL_VERSION	= 0.0.1pre-alpha

all: help

do-all: build build-kernel

build:  skernel.o skernel.out

build-kernel:
	$(info )
	$(info Creating kernel file...)
	$(OBJCOM) 	-O binary -j .text ./out/skernel.out ./out/skernel.bin
	$(info )
	$(info Compressing image file...)
	$(GZIPCOM)	./out/skernel.bin
	mv ./out/skernel.bin.gz ./out/skernel.gz
	mv ./out/skernel.gz .
	touch ./$(KERNEL_VERSION).txt

skernel.o:
	$(info )
	mkdir ./out

	$(info )
	$(info Building sources...)
	$(info)

	$(info )
	$(info Creating object files...)
	$(ASCOM) 	-o ./out/skernel.o skernel.s

skernel.out: skernel.o
	$(info )
	$(info Linking object file...)
	$(LDCOM)	-Ttext 0x07C00 -o ./out/skernel.out ./out/skernel.o

clean:
	$(info Cleaning source tree...)
	rm -fr ./out
	rm -f  ./*.gz

help:
	$(info )
	$(info * SKERNEL COMPILING OPTIONS *)
	$(info -----------------------------)
	$(info help(default): Show this text and finish)
	$(info do-all:        Build sources, and create a compressed kernel \
			      image file)
	$(info )
	$(info build:         Build sources but do not create kernel image)
	$(info build-kernel:  Create and compress kernel image file)
	$(info clean:         Delete objects and kernel image)
	$(info )
	$(info -----------------------------)
	$(info )
	$(info )
