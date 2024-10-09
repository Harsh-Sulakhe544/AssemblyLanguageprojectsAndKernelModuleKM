global _start ; entry point so _start 

; create a text section 
section .text

_start:
mov rax, 2 ; open a file using open() = 2 (OPEN SYSTEM CALL NUMBER IS 2 ON X64-LINUX )
; the file we want to open from arguements ==> rsp , dereference it using [] , stack contains these arguements , and rsp is a pointer to stack ,  go to 16 bytes ahead to get 1st arguement +8==> gives falgs
mov rdi, [rsp+16]  
mov rsi, 0 ; default flag is open-read-only == 0 
mov rdx, 0 ; default mode , cuz we are not creating any file , since it is cat command 
syscall ; to run the system-call , return the file-descriptor(fd) in rdx 

;take the contents from the file and stream them to the std::cout / out 
mov rsi, rax ; pass the file we opened (fd)to the rsi
mov rdi, 1 ; std::out  fd number  is == 1
mov rax, 40 ; sendfile systemCall number is 40 
mov rdx, 0 ; offset is 0 
mov r10, 256 ; transfer 256 bytes between files 
syscall ; to use std::out  
jmp $ ; not to exit the system-call -f elf64
