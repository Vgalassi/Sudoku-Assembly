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


    main proc   

        MOV AX,@data       ;Movendo data para ax
        MOV DS,AX
        MOV ES,AX


        MOV AH,00h
        MOV AL,3
        int 10h
   


        MOV AH, 06h        ;Cor de fundo(cinza)
        XOR AL, AL     
        XOR CX,CX     
        MOV DX, 184FH  
        MOV BH, 70h
        int 10H

        MOV AH, 06h       ;Borda esquerda
        XOR CX, CX        
        MOV DL, 6
        MOV DH,24
        MOV BH,07
        int 10H

        MOV AH, 06h      ;Borda cima
        XOR CX, CX     
        MOV DL,80
        MOV DH,2
        MOV BH,07
        int 10H

        
        MOV AH, 06h      ;Borda direita
        MOV CH,3
        MOV CL,74
        MOV DH,21
        MOV DL,80
        MOV BH,07
        int 10H

        MOV AH, 06h      ;Borda baixo   
        MOV CH,22
        MOV CL,7
        MOV DH,24
        MOV DL,80
        MOV BH,07
        int 10H


        
        MOV BH,0          
        MOV AH,2

        MOV DH,1                 ;Posicionando curso no meio superior (linha 1,coluna 32)
        MOV DL,32
        int 10h

        LEA DX,main_msg          ;Imprimindo "sudoku assembly"
        MOV AH,09
        int 21h

        
        MOV DH,4
        MOV DL,26
        

        lea SI,matriz
        call imprimematriz     ;Procedimento de imprimir matriz



        MOV BH,0
        MOV AH,02
        MOV DL,8
        int 21h

            CONTROLE:                   ;Loop de controle
                MOV AH,0
                int 16h                 ;Função de ler input do teclado

                CMP AH,1Ch
                JE TECLAENTER           ;Se for enter pular para tecla enter

                CMP AH,01h
                JE TECLAESC             ;Se for esc pular para teclaesc

                OR AL,AL
                JNE CONTROLE            ;Se for algum caractere, ler novamente

                PUSH AX
                MOV AH,03h              ;Pegando posicao do cursor
                int 10h
                POP AX


                ;Comando do cursor pelas setas 
                CMP AH,48h              
                JE CIMA

                CMP AH,50h              
                JE BAIXO
                    
                CMP AH,4Bh             
                JE ESQUERDA

                CMP AH,4Dh              
                JE DIREITA

                JMP CONTROLE

                TECLAESC:          
                    JMP FIM                 ;leva para o fim do programa

                TECLAENTER:
                    CALL coloca_valor       ;Função de mudar número acima do cursor
                    JMP CONTROLE

                CIMA:                       
                    CMP DH,4                ;Vê se o cursor ja esta no limite superior
                    JE CONTROLE
                    SUB DH,2                ;Se não estiver, mover para cima
                    JMP EXECUCAO

                BAIXO:
                    CMP DH,20              ;Vê se o cursor ja esta no limite inferior
                    JE CONTROLE
                    ADD DH,2               ;Se não estiver, mover para baixo
                    JMP EXECUCAO 

                ESQUERDA:
                    CMP DL,1Ch             ;Vê se o cursor ja esta no limite esquerdo
                    JE CONTROLE
                    SUB DL,3               ;Se não estiver, mover para esquerda
                    JMP EXECUCAO

                DIREITA:
                    CMP DL,34h             ;Vê se o cursor ja esta no limite direito
                    JE CONTROLE            
                    ADD DL,3               ;Se não estiver, mover para direita

                EXECUCAO:
                    MOV AH,02h            ;Funcao de mover o cursor de acordo com DH,DL (DH = linha, DL = coluna)
                    int 10h
                    JMP CONTROLE
                
                

        FIM:

        mov ax, 3        ;clear screen
        int 10h

        XOR DX,DX
        PUSH DX
        
        LEA SI,matriz
        CALL imprimematriz
        
        MOV AH,4CH
        int 21h
        
    

    main endp

    ;=== Procedimento de imprimir matriz 9x9 ===
    ;Imprime uma matriz 9x9 dando 2 espacos para cada coluna e 1 espaco para cada linha 
    ;Entrada:
    ;SI: Endereço da matriz 
    ;DL: Coluna do cursor
    ;DH: linha do cursor
    ;BH: página

    imprimematriz proc

        reg_push                ;Push registradores
        CLD

        MOV AH,02               ;funcao de imprimir/posicionar cursor
        MOV CX,9                ;Contador de linha 


        IMPRIME_LOOP:

                
            int 10h             ;Posiciona o cursor(Linha DH,Coluna 39)
            ADD DH,2
            PUSH DX
    
            MOV BL,9            ;BL contador de coluna
            PROXLINHA:
                imp_espaco
                imp_espaco
                LODSB           ;Armazena dado da matriz em al       
                MOV DL,AL       ;Move dado da matriz em DL e imprime
                int 21h
                
                DEC BL
                CMP BL,0
            JNE PROXLINHA       ;Acaba quando todas as colunas da linha forem impressas
            POP DX
        LOOP IMPRIME_LOOP       ;Acaba quando todas as linhas da matriz forem impressas

        reg_pop

        ret


    imprimematriz endp


    ;=== Procedimento de colocar numero na matriz ===
    ;Coloca um valor de 1 a 9 na matriz de acordo com a posição em que o cursor está
    ;Entrada:
    ;BH = página


    coloca_valor proc

        reg_push

        MOV AH,03h         ;Pegando posição do cursor
        int 10h

        XOR AX,AX

        MOV AL,DH          ;Tranformando a linha  em coordenada da matriz
        SUB AL,4
        MOV CL,2
        DIV CL
        MOV CL,9
        MUL CL

        MOV BX,AX
        XOR AX,AX

        MOV AL,DH          ;Tranformando a linha  coluna na coordenada da matriz
        MOV AL,Dl           
        SUB AL,1Ch
        MOV CL,3
        DIV CL
        MOV SI,AX


        imp_espaco          ;Imprimindo espaço para apagar o numero
    
        MOV AH,02h
        MOV Dl,8h
        int 21h             ;Backspace para voltar
    NOTNUM:
        MOV AH,07           ;Lendo o input (sem echo)
        int 21h
        CMP Al,31h          ;Verificando se o input é válido (de 1 a 9)
        JL NOTNUM
        CMP AL,39h
        JG NOTNUM

        XOR CX,CX
        MOV CL,AL

        MOV AH,02           ;Imprimindo o input
        MOV Dl,AL
        int 21h

        
        
        MOV MATRIZ[bx][si],CL    ;Colocando o valor na matriz

        MOV AH,02
        MOV Dl,8h                ;Backspace
        int 21h

        reg_pop                 ;Recuperando valores iniciais
        

        ret 

    coloca_valor endp
        




    END MAIN





            
            
            