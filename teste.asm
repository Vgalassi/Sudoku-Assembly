.model small 
.data
Hexa db "HEXA <3""$"
FraseVitoria db 10,"PARABENS VOCE TROUXE O HEXA PARA O BRASIL $"



.code
main proc

    mov ax,@data
    mov ds,ax
    xor bx,bx


    mov ah,09h
    lea dx,FraseVitoria
    int 21h
    




    
    mov ah,4ch
    int 21h





main endp
end main
