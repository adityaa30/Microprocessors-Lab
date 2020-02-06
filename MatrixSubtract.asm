data segment
  ; Declare 3x2 size array
  mat1 dw 1h, 2h, 3h, 4h, 5h, 6h

  ; Declare 3x2 size array
  mat2 dw 1h, 1h, 1h, 1h, 1h, 1h

  a dw 3h
  b dw 2h

data ends

code segment
assume cs:code, ds:data
start:
    mov ax, data
    mov ds, ax

    mov ax, a
    mul b

    mov cx, ax
    lea si, mat1
    lea di, mat2

Loop_i:
    mov ax, [si]
    mov bx, [di]
    sub ax, bx
    
    mov [si], ax
    inc si
    inc di
    dec cx
    cmp cx, 0
    jnz Loop_i

    int 3

    int 21h
code ends
end start 