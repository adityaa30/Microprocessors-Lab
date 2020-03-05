data segment
    str_inp db 'Enter string: $'
    str_success db 'OK - Input is palindrome$'
    str_fail db 'FAIL - Input is not palindrome$'
    new db '$'
    s db 20 dup(0)
data ends
code segment              
assume cs:code,ds:data
start:
    mov ax,data
    mov ds,ax

    lea dx, str_inp
    mov ah, 09h
    int 21h
    mov bx, 00
    ; input string
up:
    mov ah,01h
    int 21h
    cmp al,0dh
    je down
    mov [s+bx],al
    inc bx
    loop up
down:
    mov di,0
    dec bx
    jnz check
; bx is at end of string after input
; compare [s+bx] and [s+di]
check:
    mov al,[s+bx]
    cmp al,[s+di]
    jne fail
    inc di
    dec bx
    jnz check
    lea dx,new
    mov ah,09h
    int 21h
    lea dx, str_success
    mov ah,09h
    int 21h
    jmp finish
fail:
    lea dx, str_fail
    mov ah,09h
    int 21h
finish:
    mov ah,4ch     
    int 21h
code ends
end start
end