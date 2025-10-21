global _start
section .data
message db "Hello world!",10
length equ $ - message
failname db "txt",0
section .text
_start:
mov rax, 257
mov rdi, -100
mov rsi, failname
mov rdx, 101
mov r10, 438
syscall

mov rdi, rax
mov rax, 1
mov rsi, message
mov rdx, length
syscall

; cmp rax,length
; jz end

mov rax, 3
syscall

mov rax, 60
mov rdi, 0
syscall

end:
mov rax, 60
mov rdi, 1
syscall
