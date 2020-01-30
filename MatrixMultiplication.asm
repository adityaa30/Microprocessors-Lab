data segment
  ; Declare 5x3 size array
  mat1 
    dw 1h, 2h, 3h, 1h, 2h, 3h, 1h, 2h, 3h, 1h, 2h, 3h, 1h, 2h, 3h

  ; Declare 3x2 size array
  mat2 
    dw 1h, 2h, 1h, 2h, 1h, 2h

  ; Declare an empty 5x2 size array
  mat3 
    dw 0h, 0h, 0h, 0h, 0h, 0h, 0h, 0h, 0h, 0h 

  a dw 5h
  b dw 3h
  c dw 2h

data ends

code segment
assume cs:code, ds:data
start:



code ends
end start