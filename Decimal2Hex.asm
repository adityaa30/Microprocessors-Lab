data segment
    n dw ?
    question db '       Number: $'
    answerStatement db 'Your answer is: $'
    answer db '$'
data ends
code segment
assume cs:code, ds:data
start:

INF_LOOP:
    mov ax, data
    mov ds, ax

    ; call PrintNextLine
    ; Take input 
    mov ah, 09h
    lea dx, question
    int 21h

    call ReadNumber
    mov n, bx
    
    call BinToHex

    lea si, answer
    call ReverseString

    ; Show output 
    mov ah, 09h
    lea dx, answerStatement
    int 21h
    
    mov ah, 09h
    lea dx, answer
    int 21h
    
    jmp INF_LOOP
    
    ; Exit program
    ; mov ah, 4ch
    ; int 21h

; Procedure to convert decimal number n to hexadecimal
; Stores the ans in si register
BinToHex proc
    ; Argument is the number n
    ; Save values of ax, cx, dx registers
    push ax
    push bx
    push cx
    push dx
    
    ; Load n
    mov ax, n

    ; Load a string to store answer
    lea si, answer
LoopBinToHex:
    ; Divide the number by 16
    mov dx, 0h ; dx = 0
    mov cx, 10h ; 10h = 16
    div cx
    
    ; Now, dx has the remainder
    cmp dx, 9
    jg HandleG9
    add dx, 30h ; 30h = 48
    jmp AppendDigit

; Handle greator than 9
HandleG9:
    sub dx, 9h ; dx = dx - 9
    add dx, 40h ; 40h = 64
    jmp AppendDigit
; Append a digit to the string
AppendDigit:
    ; Save the digit
    mov [si], dx
    add si, 1h ; Add 1 for byte (2 for word)

    ; If ax <= 0 then break else continue
    cmp ax, 0h
    jnz LoopBinToHex

    ; Add '$' to the end of the string
    mov dl, '$'
    mov [si], dl

    pop dx
    pop cx
    pop bx
    pop ax
    ret

BinToHex endp

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
    lea si, answer

LoopReverseString:
    cmp cx, 0h
    je ExitReverseString

    ; Get a value from the stack into dx
    pop dx
    mov dh, 0h
    mov [si], dx

    ; Increment si and decrement count
    add si, 1h ; Add 1 for byte (2 for word)
    sub cx, 1h
    jmp LoopReverseString

ExitReverseString:
    ; Add '$' to the end of the string
    mov dl, '$'
    mov [si], dl
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
ReverseString endp


; Procedure to input a number and save to bx register
ReadNumber proc
    ; Save values of ax, cx & dx registers
    push ax
    push cx
    push dx

    ; Make bx = 0
    mov bx, 0h
LoopReadNumber:
    xor ax, ax ; ax = 0

    ; Read a character in al register
    mov ah, 1
    int 21h ; Using DOS API to take input
    
    ; Check if the input digit is [0-9]
    cmp al, '0'
    jb BreakReadNumber
    cmp al, '9'
    ja BreakReadNumber
    
    ; Ascii '0' => 30h
    sub al, 30h
    cbw ; byte to word
    cwd ; word to dword
    
    ; Make bx = (bx * 10) + ax
    push ax
    mov ax, bx
    mov cx, 10
    mul cx ; ax = ax * 10
    mov bx, ax
    pop ax
    add bx, ax

    ; Continue untill user enters a Non-Ascii Number (not in range [0-9])
    jmp LoopReadNumber

BreakReadNumber:
    pop dx
    pop cx
    pop ax
    ret
ReadNumber endp

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