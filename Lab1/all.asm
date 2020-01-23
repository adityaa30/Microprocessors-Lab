data segment
    a dw 0fffh
    b dw 0ffffh
    c dw ?
    d dw ?
    e dd ?
    f dw ?
data ends

code segment
assume cs:code, ds:data
start:
    mov ax, data
    mov ds, ax
    mov ax, a
    mov bx, b
    ; Adding the two values
    ; If there is a carry add it to cx register
    jnc store
    inc cx    
store: 
    mov word ptr c, ax
    ; Copy the most significant 16bits of ans from cx
    ; cx has carry
    mov word ptr c+2, cx
    
    mov ax, a
    mov bx, b
    ; Subtracting the two values
    sub ax, bx
    mov d, ax
    
    mov ax, a
    mov bx, b
    ; Multiplying a and b
    ; mul bx is equivalent to ax = ax * bx
    ; the extra 16bits are saved in dx registed
    ; the whole 32bit number (=a*b) is dx:ax
    mul bx 
    ; Copy the values of the ans dx:ax to e
    mov word ptr e, ax  
    mov word ptr e+2, dx
    
    
    mov ax, a
    mov bx, b
    ; Divding a and b
    ; div bx is equivalent to ax = ax / bx
    div bx 
    ; Copy the values of the ans ax to f
    mov f, ax  
    
    ; Set an interrupt for breakpoint
    int 3h
code ends
end start