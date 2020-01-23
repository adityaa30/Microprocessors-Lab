data segment
    a dw 0fffh
    b dw 0ffffh
    c dw ?
data ends

code segment
assume cs:code, ds:data
start: 
    mov ax, data
    mov ds, ax
    mov ax, a
    mov bx, b
    ; Divding a and b
    ; div bx is equivalent to ax = ax / bx
    div bx
    mov c, ax
    int 3h
code ends

end start