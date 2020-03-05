data segment
msg1 db 10,13,'enter the string: $'
msg2 db 10,13,'string is palindrome$'
msg3 db 10,13,'string is not palindrome$'
new db 10,13,'$'
s db 20 dup(0)
data ends
code segment              
assume cs:code,ds:data
start:
    mov ax,data
    mov ds,ax
    ; print welcome message
    lea dx,msg1
    mov ah,09h
    int 21h
    mov bx,00
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
    lea dx,msg2
    mov ah,09h
    int 21h
    jmp finish
fail:
    lea dx,msg3
    mov ah,09h
    int 21h
finish:
    mov ah,4ch     
    int 21h
code ends
end start
end