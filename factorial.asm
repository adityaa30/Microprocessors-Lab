data segment
  a dw 0005h
  b dw ?
data ends

code segment
assume cs:code, ds:data

start:
  mov ax, data
  mov ds, ax

  ; Starting factorial code
  mov ax, a ; Load data
  mov bx, a ; Value of i : a to 1

  cmp bx, 01
  jnz factorial
factorial:
  dec bx
  mul bx
  cmp bx, 01
  jnz factorial

  mov b, ax
  int 3

code ends
end start

