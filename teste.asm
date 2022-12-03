.model small
.stack 14h
.data
    matriz  db 9 dup('1')
            db 9 dup('1')
            db 9 dup('1')
            db 9 dup('1')
            db 9 dup('1')
            db 9 dup('1')
            db 9 dup('1')
            db 9 dup('1')
            db 9 dup('1')

    main_msg db 'Sudoku Assembly$'

.code
    imp_espaco macro    ;Macro impressão de espaço

        MOV AH,2
        MOV DL,20h
        int 21h

    ENDM

    reg_push macro      ;Macro push de registradores

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

    ENDM

    reg_pop macro      ;Macro pop de registradores

        POP DX
        POP CX
        POP BX
        POP AX

    ENDM




.code
    main proc

        MOV AX,@data       ;Movendo data para ax
        MOV DS,AX
        MOV ES,AX

        MOV Ah,0
        MOV al,4
        int 10h


        MOV AH,0BH
        MOV BH,0
        MOV BL,7
        int 10h

        MOV AH,0BH
        MOV BH,1
        MOV BL,2
        int 10h


        MOV Ah,0CH  
        MOV BH,0
        MOV AL,2
        MOV DX,100
        MOV CX,120

    XD:
    PIXEL:
        int 10h
        inc CX
        CMP CX,220
    JLE PIXEL
        ADD DX,20
        MOV CX,120
        CMP DX,150
        JLE XD


        MOV BH,0          
        MOV AH,2

        MOV DH,1               ;Posicionando curso no meio superior (linha 1,coluna 32)
        MOV DL,14
        int 10h

        LEA DX,main_msg          ;Imprimindo "sudoku assembly"
        MOV AH,09
        int 21h







        MOV AH,01
        int 21h
    


    MOV AH,4ch
    int 21h

    main endp

    END MAIN




