data segment
    a dw 000ah
    b dw 0001h
    c dw ?
data ends

code segment
assume cs:code, ds:data
start: 
    mov ax, data
    mov ds, ax
    mov ax, a
    mov bx, b
    sub ax, bx
    mov c, ax
    int 3
code ends

end start