data segment
  ; Declare 3x2 size array
  mat1 db 1h, 2h, 3h, 4h, 5h, 6h

  ; Declare 2x3 size array
  mat2 db 1h, 1h, 1h, 1h, 1h, 1h

  ; Declare an empty 3x3 size array
  mat3 db 09h dup(?) 

  small_a db 3h
  small_b db 2h
  small_c db 3h

  a dw 3h
  b dw 2h
  c dw 3h

data ends

code segment
assume cs:code, ds:data
start:
  mov ax, data
  mov ds, ax

  ; ch register store value of index i
  mov ch, small_a ; = i

  ; offset is the address from the beginning of memory segment where the variable is stored
  mov bx, offset mat3
  mov si, offset mat1

NextRow:
  ; di represents the index at mat2
  mov di, offset mat2

  ; Store the value of iterator j in cl
  mov cl, small_c ; j = c

NextCol:
  ; Store the value of iterator k in dl
  mov dl, small_b
  
  ; Store value of mat[i][j] in bp
  mov bp, 0h

NextElement:
  mov ax, 0h
  mov al, [si]
  mul byte ptr[di]
  add bp, ax
  inc si ; Go to next element in same row for mat1
  add di, c ; Go to next element in same col for mat2

  dec dl ; --k
  ; Continue iterating k from (b to 1)
  jnz NextElement

  ; Here k = 0
  ; Copy calculated value to mat3
  mov [bx], bp

  ; Now, (si => (?, b + 1) and di => (b + 1, ?))
  ; Change to (si => (?, 1) and di => (1, ? + 1))
  
  ; si: (?, b + 1) => (?, 1)
  sub si, b

  ; di: (b + 1, ?) => (1, ? + 1) => decrement by (a * b - 1)
  mov ax, a
  mul b
  dec ax
  sub di, ax

  ; Now going to next value : mat[i][j] => mat[i][j + 1] or mat[1 + 1][1]
  inc bx

  dec cl ; --j

  cmp cl, 0
  jnz NextCol

  ; End of loop having iterator j
  ; Now, change si : mat1[i][1] => mat1[i + 1][1]
  add si, b

  dec ch; --i

  cmp ch, 0
  jnz NextRow

  ; End of iterator i
  int 3 ; breakpoint

code ends
end start