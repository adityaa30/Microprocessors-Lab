data segment
    str_inp db 'Enter string: $'
    str_success db 'OK - Input is palindrome$'
    str_fail db 'FAIL - Input is not palindrome$'
    new db '$'
    s db 20 dup(0)
data ends
code segment              
assume cs:code,ds:data
start:
    mov ax,data
    mov ds,ax

    lea dx, str_inp
    mov ah, 09h
    int 21h
    ; input string

    call ReadString
    call CheckPalidrome

    ;Terminate the program
    mov ah, 4ch     
    int 21h


; Procedure to take input and save to `s`
; Length is saved in bx register
ReadString proc
    push ax
    mov bx, 00
ReadStringTakeMore:
    ; interrupt to take character input
    mov ah, 01h
    int 21h
    cmp al, 0dh
    je ReadStringDone
    mov [s+bx], al
    inc bx
    loop ReadStringTakeMore
ReadStringDone:
    pop ax
    ret
ReadString endp

; Procedure to check if string is palidrome
; String length should be in bx
CheckPalidrome proc
    push di
    
    ; Two counter variables:
    ; i is di which start from left
    ; j is bx which start from right
    mov di, 0
    dec bx
; bx is at end of string after input
; compare [s+bx] and [s+di]
CheckPalidromeChar:
    mov al, [s+bx]
    cmp al, [s+di]
    jne CheckPalidromeFail
    inc di ; ++i
    dec bx ; --j
    jnz CheckPalidromeChar
    
    ; Everthing is ok -> Palidrome string
    lea dx, str_success
    mov ah, 09h
    int 21h
    jmp CheckPalidromeEnd
CheckPalidromeFail:
    lea dx, str_fail
    mov ah,09h
    int 21h
CheckPalidromeEnd:
    pop di
    ret
CheckPalidrome endp

code ends
end start