.model small 
.data
Hexa db "HEXA<3$"
FraseVitoria db "PARABENS VOCE TROUXE O HEXA PARA O BRASIL$"



.code
main proc

    mov ax,@data
    mov ds,ax
    xor bx,bx



;640x200
    MOV ah,00h
    MOV al,0eh
    int 10h


    MOV AH,02
    MOV DH,6              ;Posicionando cursor no meio superior (linha 1,coluna 32)
    MOV DL,17
    MOV BH,0
    int 10h

    mov ah,09h
    lea dx,FraseVitoria
    int 21h
        








;VERDE PROC

; draw pixel -coluna -linha  -cor

    mov ah,0CH
    mov cx,160
    mov dx,103
    mov al,2



linhavertical1:
    int 10h
    inc dx
    cmp dx,181
    jne linhavertical1

    
; draw pixel -coluna -linha  -cor

    mov ah,0CH
    mov cx,160
    mov dx,103
    mov al,2
linhahorizontal1:
    int 10h
    inc cx
    cmp cx,467
    jne linhahorizontal1
; draw pixel -coluna -linha  -cor

    mov ah,0CH
    mov cx,160
    mov dx,180
    mov al,2
linhahorizontal2:
    int 10h
    inc cx
    cmp cx,467
    jne linhahorizontal2

; draw pixel -coluna -linha  -cor

    mov ah,0CH
    mov cx,467
    mov dx,103
    mov al,2
linhavertical2:
    int 10h
    inc dx
    cmp dx,181
    jne linhavertical2
;VERDE ENDP


;AMARELO PROC
; draw pixel -coluna -linha  -cor

    mov ah,0CH
    mov cx,160
    mov dx,141
    mov al,14
linha:
    int 10h
    inc cx
    int 10h
    inc cx
    int 10h
    inc cx
    int 10h
    inc cx
    
    
    
    int 10h
    inc dx
    
    cmp cx,312
    jne linha
; draw pixel -coluna -linha  -cor

    mov ah,0CH
    mov cx,312
    mov dx,103
    mov al,14
linha4:
    int 10h
    inc cx
    int 10h
    inc cx
    int 10h
    inc cx
    int 10h
    inc cx
    
    
    
    int 10h
    inc dx
    
    cmp dx,142
    jne linha4
; draw pixel -coluna -linha  -cor

    mov ah,0CH
    mov cx,312
    mov dx,179
    mov al,14
linha2:
    int 10h
    inc cx
    int 10h
    inc cx
    int 10h
    inc cx
    int 10h
    inc cx
    
    int 10h
    dec dx
    
    cmp dx,140
    jne linha2

; draw pixel -coluna -linha  -cor

    mov ah,0CH
    mov cx,160
    mov dx,141
    mov al,14
linha3:
    int 10h
    inc cx
    int 10h
    inc cx
    int 10h
    inc cx
    int 10h
    inc cx
    
    int 10h
    dec dx
    
    cmp dx,103
    jne linha3
;AMARELO ENDPROC

;AZUL PROC
; draw pixel -coluna -linha  -cor

    mov ah,0CH
    mov cx,260
    mov dx,123
    mov al,1


pinta:
quadrado:
    int 10h
    inc dx
    cmp dx,160
    jne quadrado

    mov dx,123
    inc cx
    cmp cx,365
    jne pinta
;AZUL ENDPROC

MOV AH,02
MOV DH,17              ;Posicionando cursor no meio superior (linha 1,coluna 32)
MOV DL,37
MOV BH,0
int 10h

mov ah,09h
lea dx,Hexa
int 21h





    
mov ah,4ch
int 21h





main endp
end main
