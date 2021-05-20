    bits 64
    extern printf
    section .bss    
    section .data
;; msg: db "Hello, ASM World", 0x10
;; a:  db 0x41
;; arr: times 0x0A db 0x41
;; newline:    db 0x0A
fmt:   db  "%d", 0x0A
    
    section .text   
    global _start

;; print_newline:
;;     push rax
;;     mov rax, 0x01
;;     mov rdi, 0x01
;;     mov rsi, newline
;;     mov rdx, 0x01
;;     syscall
;;     pop rax
;;     ret
    
;; print_hello_world:
;;     push rax
;;     mov rax, 0x01               ; sys_write
;;     mov rdi, 0x01               ; set fd stdout and first argument
;;     mov rsi, msg                ; second argument. const char *
;;     mov rdx, 0x10               ; length and third argument. uint
;;     syscall
;;     pop rax
;;     ret

;; print_arr:
;;     push rax
;;     mov rax, 0x01               ; sys_write(int, char *cont, size_t)
;;     mov rdi, 0x01               ; set fd stdout and first argument
;;     lea rbx, [arr]              ; set pointer
;;     mov [rbx], byte 0x42        ; substitution
;;     mov rsi, rbx                ; second argument. const char *
;;     mov rdx, 0x01               ; length and third argument. size_t
;;     syscall
;;     pop rax
;;     ret


fact:
    push rax                    ; evacuate rax.
    xor rax, rax                ; init rax, same rax = 0.
    inc rax                     ; increment rax, same ++rax.
    mov rcx, 0x05               ; set target number to rcx, specified 5 here. rcx is counter register.
    .loop mul rcx               ; .loop label and multiply rax * rcx.
    dec rcx                     ; decrement rcx.
    cmp rcx, 0x01               ; compare between rcx and 0x01
    jg .loop                    ; goto .loop label when result of compare is greater than 0x01.
    xor rcx, rcx                ; init rcx, same rcx = 0
    mov rsi, rax                ; copy from rax to rsi.
    mov rdi, fmt                ; set printf format.
    xor rax, rax                ; init rax
    call printf                 ; call printf function
    pop rax                     ; return first rax
    ret                         ; exit function
    
    
_start:
    xor rax, rax
    mov rdx, rax
    ;; call print_hello_world
    ;; call print_arr
    ;; call print_newline
    call fact
    xor rdi, rdi                ; init 0
    mov rax, rdi                ; set return value
    mov al, 0x3c                ; sys_exit
    syscall

