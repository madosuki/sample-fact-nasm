#!/bin/sh

nasm -f elf64 ./main.asm

gcc -nostartfiles -no-pie main.o
