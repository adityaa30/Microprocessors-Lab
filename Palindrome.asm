data segment
    str_inp db 'Enter string: $'
    input db '$'
data ends


code segment
assume cs:code, ds:data
start:
mov ax, data
mov ds, ax


; Procedure to input a number and save to palindrome register
ReadString proc
    ; Save values of ax, cx & dx registers
    push ax
    push bx
    push cx
    push dx
    push si

    lea si, palindrome
LoopReadString:
    ; Read a character in al register
    mov ah, 1
    int 21h ; Using DOS API to take input
    
    ; Check if the input is [a-z]
    cmp al, 'a'
    jb BreakReadString
    cmp al, 'z'
    ja BreakReadString
    
    ; Save the digit
    mov [si], al
    add si, 1h ; Add 1 for byte (2 for word)

    ; Continue untill user enters a invalid character
    jmp LoopReadString

BreakReadString:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
ReadString endp

; Prints newline
PrintNextLine proc
    push ax
    push dx
    
    mov dl, 10
    mov ah, 02h
    int 21h
    mov dl, 13
    mov ah, 02h
    int 21h

    pop dx
    pop ax
    ret
PrintNextLine endp

code ends
end start
