.model small

pixelp MACRO xp,yp,corp
    pushall

    MOV AH, 0CH
    MOV AL, corp
    MOV CX, xp
    MOV DX, yp 
    MOV BH, 0
    INT 10H

    popall
ENDM

pushall MACRO
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
ENDM

popall MACRO
    POP DX
    POP CX
    POP BX
    POP AX

ENDM


linha MACRO xl,yl,taml,corl
    LOCAL VOLTAL
    pushall
    MOV AH, tamL
    INC AH
    MOV CX, xl  
    MOV DX, yl 
    MOV AL, corl 
    VOLTAL:
        pixelp CX, DX, AL
        INC CX  
        dec AH
        jnz VOLTAL
    popall
ENDM

coluna MACRO xc, yc, tamc, corc
    LOCAL VOLTAC
    pushall
    MOV AH, tamc 
    INC AH
    MOV CX, xc
    MOV DX, yc
    MOV AL, corc
    VOLTAC:
        pixelp CX, DX, AL
        INC DX
        DEC AH
        JNZ VOLTAC 

    popall

ENDM

interface MACRO xi,yi,tami,cori

    pushall
    XOR AH, AH
    MOV AL, tami 
    MOV CL, 9
    DIV CL 

    MOV BL, AL
    MOV CX, xi
    MOV DX, yi
    MOV AH, 10
    MOV AL, cori

    pushall
    COLUNAI:
        MOV BH, tami 
        coluna CX, DX, BH, AL
        XOR BH, BH
        ADD CX, BX
        DEC AH
        JNZ COLUNAI
    popall

    pushall 
    LINHAI:
        MOV BH, tami 
        linha CX, DX, BH, AL
        XOR BH, BH
        ADD DX, BX
        DEC AH
        JNZ LINHAI

    popall
ENDM 
.data
    matriz  db 9 dup('?')
            db 9 dup('?')
            db 9 dup('?')
            db 9 dup('?')
            db 9 dup('?')
            db 9 dup('?')
            db 9 dup('?')
            db 9 dup('?')
            db 9 dup('?')

.code
    main proc   

        MOV AX,@data
        MOV DS,AX
        MOV ES,AX


        MOV AH, 0
        MOV AL, 13
        INT 10H 

        XOR AX, AX

        MOV AH, 0BH
        MOV BH, 0

        MOV BL, 00H
        INT 10H
        
        CALL imprimematriz
        interface 10,10,135,5


       
        
        MOV AH,01
        int 21h

        MOV AH,4CH
        int 21h
        
    

    main endp

    ;Procedimento de imprimir matriz
    ;Entrada:
    ;N/A
    ;Saída:
    ;   CX = 81
    ;   BX = 9
    ;   DF = 0
    ;   AH = 02
    imprimematriz proc

        MOV AH,02
        MOV CX,9
        CLD

        lea SI,matriz

        IMPRIME_LOOP:
            MOV BH,9
            MOV DL,10
            int 21h
            PULALINHA:
                MOV DL,20h
                int 21h
                LODSB
                MOV DL,AL
                int 21h
                
                DEC BH
                CMP BH,0
            JNE PULALINHA
        LOOP IMPRIME_LOOP

        ret


    imprimematriz endp




    END MAIN





            
            
            