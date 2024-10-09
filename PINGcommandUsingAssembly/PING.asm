global _start

section .data

address: 
    dw 2                ; define word for address family (AF_INET)
    dw 0                ; port number (0 for ICMP)
    db 8                ; IP address (example: 8.0.0.0)
    db 0
    db 0
    db 0
    dd 0                ; zero out the rest of the address structure
    dd 0 

packet:
    db 8                ; ICMP type (Echo Request)
    db 0                ; ICMP code
    dw 0                ; checksum (initially 0)
    db 0                ; identifier
    db 0                ; sequence number
    db 0                ; payload (optional)
    
good:
    db 'good', 0        ; null-terminated string

section .bss
buffer: 
    resb 1024           ; reserve 1024 bytes for the incoming packet

section .text

_start:
    ; Create socket
    mov rax, 41         ; syscall: socket
    mov rdi, 2          ; AF_INET
    mov rsi, 3          ; SOCK_RAW
    mov rdx, 1          ; IPPROTO_ICMP
    syscall 
    mov r12, rax        ; save socket file descriptor

    ; Prepare packet
    ; Calculate checksum here (simple example, not complete)
    mov rax, 0          ; reset checksum
    mov [packet + 2], ax ; store checksum in packet

    ; Send packet
    mov rax, 44         ; syscall: sendto
    mov rdi, r12        ; socket file descriptor
    mov rsi, packet     ; packet buffer
    mov rdx, 8          ; packet length
    mov r10, 0          ; flags
    mov r8, address     ; address buffer
    mov r9, 16          ; length of address buffer
    syscall 

    ; Receive packet
    mov rax, 45         ; syscall: recvfrom
    mov rdi, r12        ; socket file descriptor
    mov rsi, buffer     ; buffer to receive packet
    mov rdx, 1024       ; buffer length
    mov r10, 0          ; flags
    mov r8, address     ; address buffer
    mov r9, 16          ; length of address buffer
    syscall 

    ; Check if the response is valid
    cmp word [buffer + 20], 0 ; check the ICMP type
    jne failure                ; jump if not equal

    ; Print "good"
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; file descriptor: stdout
    mov rsi, good       ; pointer to string
    mov rdx, 4          ; length of string
    syscall

failure:
    ; Handle failure (could print an error message or exit)
    mov rax, 60         ; syscall: exit
    xor rdi, rdi        ; exit code 0
    syscall

