; Program for calculating n'th fibonacci number

data segment
    n dw 5h
data ends

code segment
assume cs:code, ds:data
start:
  mov ax, data
  mov ds, ax

  ; ax => a (=0 initially)
  mov ax, 0
  ; bx => b (=1 initially)
  mov bx, 1
  ; cx => c (=0 initially)
  mov cx, 0

InitLoop:
  ; Initialize iterator
  mov dx, n
  sub dx, 2

Loop_i:
  ; This loop runs untill dx is 0
  ; c = a + b
  add cx, bx
  add cx, ax

  ; Update values
  mov ax, bx ; a = b
  mov bx, cx ; b = c

  dec dx
  cmp dx, 0
  jg Loop_i

  int 3

code ends
end start