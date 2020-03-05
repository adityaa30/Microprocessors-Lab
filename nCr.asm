data segment
  n dw ?
  r dw ?
  str_n db 'Enter n: $'
  str_r db 'Enter r: $'
data ends

code segment
assume cs:code, ds:data

start:
  mov ax, data
  mov ds, ax

  call PrintNextLine
  mov ah, 09h
  lea dx, str_n
  int 21h
  call ReadNumber
  mov n, bx
  
  call PrintNextLine
  mov ah, 09h
  lea dx, str_r
  int 21h
  call ReadNumber
  mov r, bx

  mov bx, n
  call Factorial
  mov ax, bx ; Save n! to ax

  mov bx, r
  call Factorial
  div bx ; Save (n! / r!) to ax

  mov bx, n
  sub bx, r
  call Factorial 
  div bx ; Save (n! / (r! * (n-r)!)) to ax

  mov bx, ax
  call PrintBx

Factorial proc
  ; Assume input is in bx
  ; Output is in bx
  push ax
  push cx
  push dx

  ; Starting factorial code
  mov cx, bx ; Value of i : a to 1

  cmp cx, 01
  jnz factorial
factorial:
  dec cx
  mul cx
  cmp cx, 01
  jnz factorial

  pop dx
  pop cx
  pop ax
  ret
Factorial endp

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
    mov ah, 09h
    mov dx, offset lnfd
    int 21h
    pop dx
    pop ax
    ret
PrintNextLine endp

PrintBx proc
    push ax ; Store current value of ax

    ; Print Most Significant Nibble in bx
    mov ax, bx
    shr ax, 12 ; Shift Right by 3 nibbles to get most significant nibble of bx in least of ax

    mov dl, al
    add dl, "0" ; Convert to ASCII from hex
    cmp dl, "9"
    jle cont0
    add dl, 7
    cont0:
    mov ah, 02h ; Print character to stdout
    int 21h

    ; Print Second Most Significant Nibble in bx
    mov ax, bx
    and ax, 0F00h ; Make all nibbles 0 other than second most significant
    shr ax, 8 ; Shift Right by 2 nibbles to get second most significant nibble of bx in least of ax

    mov dl, al
    add dl, "0" ; Convert to ASCII from hex
    cmp dl, "9"
    jle cont1
    add dl, 7
    cont1:
    mov ah, 02h ; Print character to stdout
    int 21h

    ; Print Second Least Significant Nibble in bx
    mov ax, bx
    and ax, 00F0h ; Make all nibbles 0 other than second least significant
    shr ax, 4 ; Shift Right by 1 nibble to get second least significant nibble of bx in least of ax

    mov dl, al
    add dl, "0" ; Convert to ASCII from hex
    cmp dl, "9"
    jle cont2
    add dl, 7
    cont2:
    mov ah, 02h ; Print character to stdout
    int 21h

    ; Print Least Significant Nibble in bx
    mov ax, bx
    and ax, 000Fh ; Make all nibbles 0 other than least significant

    mov dl, al
    add dl, "0" ; Convert to ASCII from hex
    cmp dl, "9"
    jle cont3
    add dl, 7
    cont3:
    mov ah, 02h ; Print character to stdout
    int 21h

    pop ax ; Restore value of ax
    ret
PrintBx endp



code ends
end start

