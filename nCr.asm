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

  aam
  mov bx, ax
  call PrintNextLine
  mov ah, 09h
  lea dx, str_ans
  int 21h
  ; Print the number
  
  call PrintBx

  
  ;to terminate the program
  mov ah, 4ch     
  int 21h

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

; Print number
PrintBx proc
    mov dl, bh ; since the values are in bx, bh part
    add dl, 30h ; ascii adjustment
    mov ah, 02h ; to print in dos
    int 21h
    mov dl, bl ; bl part 
    add dl, 30h ; ascii adjustment
    mov ah, 02h ; to print in dos
    int 21h
    ret
PrintBx endp      

code ends
end start

