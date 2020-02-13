data segment
    string db "Sample String!$"
data ends

code segment
assume cs:code, ds:data
start:
    mov ax, data
    mov ds, ax


; Reverses the string stored with Effective address in si register
ReverseString proc
    push ax
    push bx
    push cx
    push dx

StartEmptying:
    mov cx, 0h

LoopEmptyString:
    ; Check if last character
    mov ax, [si]
    cmp al, '$'
    je StartReversing

    ; Else push to stack and repeat
    push [si]
    add si, 1h ; Add 1 for byte (2 for word)
    add cx, 1h
    jmp LoopEmptyString

StartReversing:
    ; Load the string
    lea si, string

LoopReverseString:
    cmp cx, 0h
    je ExitReverseString

    pop dx
    mov dh, 0h
    mov [si], dx

    ; Increment si and decrement count
    add si, 1h ; Add 1 for byte (2 for word)
    sub cx, 1h
    jmp LoopReverseString

ExitReverseString:
    ; Add '$' to the end of the string
    mov [si], '$'
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
ReverseString endp

end code
start ends
