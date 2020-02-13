DATA SEGMENT
A DW 11
C DW ?
DATA ENDS
CODE SEGMENT
         ASSUME DS:DATA,CS:CODE
START:
      CALL ReadNumber
      MOV AX,DATA
      MOV DS,AX
      MOV AX,BX
      MOV BX,AX
      SHR AX,1
      XOR BX,AX
      MOV C,BX      
      INT 3


ReadNumber proc
    
    push ax
    push cx
    push dx

    
    mov bx, 0h
LoopReadNumber:
    xor ax, ax 
 
    mov ah, 1
    int 21h 
 
    cmp al, '0'
    jb BreakReadNumber
    cmp al, '9'
    ja BreakReadNumber
    sub al, 30h
    cbw 
    cwd  
    push ax
    mov ax, bx
    mov cx, 10
    mul cx 
    mov bx, ax
    pop ax
    add bx, ax
    jmp LoopReadNumber

BreakReadNumber:
    pop dx
    pop cx
    pop ax
    ret
ReadNumber endp

CODE ENDS
END START