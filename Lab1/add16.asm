data segment
    a dw 0202h
    b dw 0901h
    c dd ?
data ends

code segment
assume cs:code, ds:data
start: 
    mov ax, data
    mov ds, ax
    mov ax, a
    mov bx, b
    add ax, bx
    ; If there is a carry add it to cx register
    jnc store
    inc cx    
store: 
    mov word ptr c, ax
    ; Copy the most significant 16bits of ans from cx
    ; cx has carry
    mov word ptr c+2, cx
    int 3
code ends

end start