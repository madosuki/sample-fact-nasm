#!/bin/sh

nasm -f elf64 main.asm && ld -o a.out main.o
