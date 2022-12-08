.model small 
.data




.code
main proc

    mov ax,@data
    mov ds,ax
    xor bx,bx
    
    MOV AH,02
    MOV DH,1               ;Posicionando cursor no meio superior (linha 1,coluna 32)
    MOV DL,32
    MOV BH,0
    int 10h
    
;640x200
    MOV ah,00h
    MOV al,0eh
    int 10h

; draw pixel -coluna -linha  -cor

    mov ah,0CH
    mov cx,160
    mov dx,100
    mov al,1
linha:
    int 10h
    inc cx
    inc dx
    cmp cx,200
    jne linha

    

    
    mov ah,4ch
    int 21h
main endp
end main

