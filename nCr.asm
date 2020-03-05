data segment
  n dw ?
  r dw ?
  str_n db 'Enter n: $'
  str_r db 'Enter r: $'
  str_ans db 'Answer: $'
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
  push bx ; Save n! to stack

  mov bx, r
  call Factorial
  push bx ; Save r! to stack

  mov bx, n
  sub bx, r
  call Factorial 
  push bx ; Save (n-r)! to stack

  pop cx
  pop bx
  pop ax
  div bx
  div cx

  mov bx, ax
  call PrintNextLine
  mov ah, 09h
  lea dx, str_ans
  int 21h
  ; Print the number
  
  call printBx

Factorial proc
  push ax
  mov ax, 1
  call FactorialHelper
  mov bx, ax
  pop ax
  ret
Factorial endp


FactorialHelper proc
  cmp bx, 1
  jz FactorialHelperResult
  mul bx
  sub bx, 1
  call FactorialHelper 
FactorialHelperResult:
  ret
endp

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

 printBx proc
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
printBx endp


; Procedure to print value in ax register
PrintDecimal proc            
  push bx
  push cx
  push dx

  ; initilize count 
  mov cx, 0 
  mov dx, 0 
PrintLoop: 
  ; if ax is zero 
  cmp ax, 0
  je PrintStuff
   
  mov bx, 0ah ; initilize bx to 10         
  mov dx, 0h ; Make dx = 0

  div bx ; extract the last digit 
  push dx ; push it in the stack 
  inc cx ; increment the count 
    
  jmp PrintLoop 
PrintStuff: 
  cmp cx, 0 ; If cx = 0 then stop
  je PrintEnd
    
  ; pop the top of stack 
  pop dx 
    
  ; add 48 so that it  
  ; represents the ASCII 
  ; value of digits 
  add dx, 030h
    
  mov ah, 02h ; interuppt to print a character  
  int 21h 
  
  dec cx ; decrease the count  
  jmp PrintStuff 
PrintEnd:

  pop dx
  pop cx
  pop bx
  ret 
PrintDecimal endp 

code ends
end start

