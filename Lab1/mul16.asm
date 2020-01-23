data segment
    a dw 0fffh
    b dw 0ffffh
    c dd ?
data ends

code segment
assume cs:code, ds:data
start: 
    mov ax, data
    mov ds, ax
    mov ax, a
    mov bx, b
    ; Multiplying a and b
    ; mul bx is equivalent to ax = ax * bx
    ; the extra 16bits are saved in dx registed
    ; the whole 32bit number (=a*b) is dx:ax
    mul bx
    ; Copy the values of the ans dx:ax to c
    mov word ptr c,ax
    mov word ptr c+2,dx
    int 3h
code ends

end start