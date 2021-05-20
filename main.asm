    bits 64
    extern printf
    section .bss    
    section .data
msg: db "Hello, ASM World", 0x10
a:  db 0x41
arr: times 0x0A db 0x41
fmt:   db  "%d", 2
newline:    db 0x0A
    
    section .text   
    global _start

print_newline:
    push rax
    mov rax, 0x01
    mov rdi, 0x01
    mov rsi, newline
    mov rdx, 0x01
    syscall
    pop rax
    ret
    
print_hello_world:
    push rax
    mov rax, 0x01               ; sys_write
    mov rdi, 0x01               ; set fd stdout and first argument
    mov rsi, msg                ; second argument. const char *
    mov rdx, 0x10               ; length and third argument. uint
    syscall
    pop rax
    ret

print_arr:
    push rax
    mov rax, 0x01               ; sys_write(int, char *cont, size_t)
    mov rdi, 0x01               ; set fd stdout and first argument
    lea rbx, [arr]              ; set pointer
    mov [rbx], byte 0x42        ; substitution
    mov rsi, rbx                ; second argument. const char *
    mov rdx, 0x01               ; length and third argument. size_t
    syscall
    pop rax
    ret


fact:
    push rax
    xor rax, rax
    inc rax
    mov rcx, 0x05
    .loop mul rcx
    dec rcx
    cmp rcx, 0x01
    jg .loop
    xor rcx, rcx
    mov rsi, rax
    mov rdi, fmt
    xor rax, rax
    call printf
    pop rax
    ret
    
    
_start:
    xor rax, rax
    mov rdx, rax
    ;; call print_hello_world
    call print_arr
    call print_newline
    call fact
    xor rdi, rdi                ; init 0
    mov rax, rdi                ; set return value
    mov al, 0x3c                ; sys_exit
    syscall

