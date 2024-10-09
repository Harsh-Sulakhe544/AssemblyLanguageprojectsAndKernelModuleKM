global _start

section .data 

buffer:
times 256 db 0 ;  256 bytes buffer all bits set to 0  (times is like for loop )

section .text

_start:
mov rax , 79 	; get  getcurentWorkingDirectory() - sytemCall == 79 = rax 
mov rdi , buffer ; get  getcurentWorkingDirectory() == rdi 
mov rsi , 256 ; size of the buffer in bytes = 2nd arguement 
syscall 

; to print the path 
mov rax , 1 ; rax = write system call number   -- file descriptor(fd)
mov rdi , 1 ; ==> fd number is 1 for std::out 
mov rsi, buffer; rsi is the buffer to write 
mov rdx, 256 ; count of bytes to write 
syscall

jmp $ ; saf execution of a c program 

