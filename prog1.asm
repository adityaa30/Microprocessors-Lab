data segment
data ends
assume cs: code, ds: data
code segment
start: 
    mov ax,data
    mov ds,ax
; AH = 2Ch - GET SYSTEM TIME
; Return: CH = hour CL = minute DH = second DL = 1/100 seconds
    hour:
        mov ah,2ch    
        int 21h
        mov al,ch     
        aam ; ascii adjust after multiply
        mov bx,ax
        call disp

        mov dl,':'
        mov ah,02h    
        int 21h

    minutes:
        mov ah,2ch    
        int 21h
        mov al,cl     
        aam
        mov bx,ax
        call disp

        mov dl,':'   
        mov ah,02h
        int 21h
    
    seconds:
        mov ah,2ch    
        int 21h
        mov al,dh     
        aam
        mov bx,ax
        call disp

        mov dl,':'   
        mov ah,02h
        int 21h

    milliseconds:
        mov ah,2ch    
        int 21h
        mov al,dl     
        aam
        mov bx,ax
        call disp


    ;to terminate the program
    mov ah,4ch     
    int 21h

    ;display part
    disp proc
    mov dl,bh      ; since the values are in bx, bh part
    add dl,30h     ; ascii adjustment
    mov ah,02h     ; to print in dos
    int 21h
    mov dl,bl      ; bl part 
    add dl,30h     ; ascii adjustment
    mov ah,02h     ; to print in dos
    int 21h
    ret
    disp endp      

code ends
end start      