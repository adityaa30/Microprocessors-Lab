PrintNextLine proc
    push ax
    push dx

    mov dx,13
    mov ah,2
    int 21h  
    mov dx,10
    mov ah,2
    int 21h

    pop dx
    pop ax
PrintNextLine endp