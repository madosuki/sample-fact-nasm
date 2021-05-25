    bits 64
    extern printf
    section .bss    
    section .data
arr: times 0xA db 0x0
fmt:   db  "%d", 0x0A, 0
    
    section .text   
    global _start

   

atoi:
    xor rcx, rcx                ; int i = 0
    .detect_digit_loop: nop
    inc rcx
    cmp [arr+rcx-1], byte 0xA   ; detect lf code
    jg .detect_digit_loop       ; if (char > 0)
    dec rcx
    mov rax, rcx
    xor rax, rax
    xor rdi, rdi                ; int times
    inc rdi                     ; same times = 1
    .convert: nop
    dec rcx
    push rax                    ; evacutate rax
    movsx rax, byte [arr+rcx]   ; char c = target[rcx] 
    sub rax, 0x30               ; rbx -= '0'. meanse convert char code to number
    mul rdi                     ; rax *= rdi
    xor rax, rdx                ; get mul result from rax and rdx
    mov rbx, rax                ; swap
    pop rax,                    ; recover rax
    add rax, rbx                ; rax + rbx
    push rax                    ; evacuate rax
    mov rax, rdi                ; rax = rdi
    mov rdx, 0xA                ; set 10
    mul rdx                     ; times * 10
    xor rax, rdx
    xor rdx, rdx
    mov rdi, rax                ; update times
    pop rax                     ; recovery rax
    cmp rcx, 0x0                ; if rcx == 0
    jne .convert
    xor rdi, rdi
    xor rbx, rbx
    ret

;; print_int:
;;     push rax
;;     xor rax, rax                ; syscall no 0
;;     xor rdi, rdi                ; fd no 0 = stdin
;;     lea rsi, [rel arr]          ; set buffer
;;     mov rdx, 0x0A               ; set buffer size
;;     syscall
;;     call atoi
;;     mov rsi, rax
;;     mov rdi, fmt
;;     call printf
;;     pop rax
;;     ret


fact:
    mov rcx, rax               ; set target number to rcx, specified 5 here. rcx is counter register.
    xor rax, rax
    inc rax
    .loop mul rcx               ; .loop label and multiply rax * rcx.
    xor rax, rdx
    dec rcx                     ; decrement rcx.
    cmp rcx, 0x01               ; compare between rcx and 0x01
    jg .loop                    ; goto .loop label when result of compare is greater than 0x01.
    xor rcx, rcx                ; init rcx, same rcx = 0
    ret                         ; exit function

fact_with_stdin:
    push rax
    xor rax, rax                ; syscall no 0
    xor rdi, rdi                ; fd no 0 = stdin
    lea rsi, [rel arr]          ; set buffer
    mov rdx, 0x0A               ; set buffer size
    syscall
    call atoi
    call fact
    mov rsi, rax                ; copy from rax to rsi.
    mov rdi, fmt                ; set printf format.
    call printf                 ; call printf function
    pop rax
    ret
    
    
_start:
    xor rax, rax
    mov rdx, rax
    call fact_with_stdin
    xor rdi, rdi                ; init 0
    mov rax, rdi                ; set return value
    mov al, 0x3c                ; sys_exit
    syscall

