.model small
.stack 14h
.data
    matriz_pr1 db '5','3',2 dup(' '),'7',4 dup(' ')
            db '6',2 dup(' '),'1','9','5',3 dup(' ')
            db ' ','9','8',4 dup(' '),'6',' '
            db '8',3 dup(' '),'6',3 dup(' '),'3'
            db '4',2 dup(' '),'8',' ','3',2 dup(' '),'1'
            db '7',3 dup(' '),'2',3 dup(' '),'6'
            db ' ','6',4 dup(' '),'2','8',' '
            db 3 dup(' '),'4','1','9',2 dup(' '),'5'
            db 4 dup(' '),'8',2 dup(' '),'7','9'

    matriz_pr2 db ' ','6',' ','1',' ','4',' ','5',' '
            db 2 dup(' '),'8','3',' ','5','6',2 dup(' ')
            db '2',7 dup(' '),'1'
            db '8',2 dup(' '),'4',' ','7',2 dup(' '),'6'
            db 2 dup(' '),'6',3 dup(' '),'3',2 dup (' ')
            db '7',2 dup(' '),'9',' ','1',2 dup(' '),'4'
            db '5',7 dup (' '),'2'
            db 2 dup(' '),'7','2',' ','6','9',2 dup(' ')
            db ' ','4',' ','5',' ','8',' ','7',' '


    matriz  db 9 dup (' ')
            db 9 dup (' ')
            db 9 dup (' ')
            db 9 dup (' ')
            db 9 dup (' ')
            db 9 dup (' ')
            db 9 dup (' ')
            db 9 dup (' ')
            db 9 dup (' ')


    vetor_val dw 60 dup (' ')       ;Vetor para guardar posição dos valores imutáveis


    vetor_aux db '1','2','3','4','5','6','7','8','9'   ;Vetor para validação de vitória

    main_msg db 'Sudoku Assembly$'
    controle_msg db 'Controles:$'
    clique_msg db 'Para por valores$'
    clique2_msg db 'na tabela, clique$'
    clique3_msg db 'no espaco e digite$'
    clique4_msg db 'um valor entre 1 a 9$'

    flag db '?'
.code
    imp_espaco macro    ;Macro impressão de espaço
        PUSH AX
        PUSH DX
        MOV AH,2
        MOV DL,20h
        int 21h
        POP DX
        POP AX

    ENDM

    Imprime_msg macro var1   ;macro para codigo de impressão 
         
        PUSH AX
        PUSH DX
        MOV AH, 09h
        LEA DX,var1
        INT 21h
        POP DX
        POP AX

    ENDM


    imp_back macro    ;Macro impressão de backspace

        PUSH AX
        PUSH DX
        MOV AH,2
        MOV DL,8h
        int 21h
        POP DX
        POP AX

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
        MOV al,0Eh            ;Ativando modo se vídeo CGA 640x200
        int 10h


        MOV AH,0BH
        MOV BH,0            ;Cor de fundo preto (bl = 0)
        MOV BL,0
        int 10h

        MOV AH,0BH
        MOV BH,1            ;Seleção de paleta
        MOV BL,0
        int 10h

        LEA SI,matriz_pr2
        CALL atribui_matriz

        MOV AH,02
        MOV DH,1               ;Posicionando cursor no meio superior (linha 1,coluna 32)
        MOV DL,32
        MOV BH,0
        int 10h

        Imprime_msg main_msg       ;Imprimindo "sudoku assembly"

        MOV DH,7              ;Posicionando curso na esquerda (linha 7,coluna 1)
        MOV DL,1
        MOV BH,0
        int 10h

        Imprime_msg controle_msg

        ADD DH,2                    ;Para cada mensagem, mover o cursor para a próxima linha
        int 10h

        Imprime_msg clique_msg

        inc DH
        int 10h

        Imprime_msg clique2_msg

        inc DH
        int 10h

        Imprime_msg clique3_msg

        inc DH
        int 10h

        Imprime_msg clique4_msg


        CALL valores_imutaveis   ;Chamar procedimento para guardar valores imutaveís no veto val

    

        MOV DH,5               ;Posição da matriz (primeira linha)
        MOV DL,26
        lea SI,matriz
        call imprimematriz     ;Procedimento de imprimir matriz




       call grade               ;Procedimento de imprimir grade do sudoku

        imp_back
        mov ax, 02h            ;Ativando cursor(mouse)
        int 33h

        XOR CX,CX
        XOR DX,DX


        CONTROLE:              ;Loop para controles com o mouse           
                mov  ax, 3h 
                int  33h 
                TEST bx,1
        JZ CONTROLE                  ;Pular se não houver clique no mouse
                                     ;Valor inicial da coluna 214(+24)->430,Valor inicial da linha 36(+16)->180
                CMP CX,214      
                JL CONTROLE
                CMP CX,430           ;Verificando se o clique do mouse está dentro da grade
                JG CONTROLE
                CMP DX,36             
                JL CONTROLE
                CMP DX,180
                JG CONTROLE
                                    ;Verificando se o clique está dentro da coluna
                XOR AX,AX
                MOV AH,3
                MOV AL,24            ;Convertendo a posição do mouse em posição de char
                MOV BX,36
            
                LINHABOTAO:
                    ADD AH,2         ;Convertendo a posição da linha para char
                    ADD BX,16
                    CMP DX,BX
                    JNL LINHABOTAO

                XOR BX,BX
                MOV BX,214

                    COLUNABOTAO:
                        ADD AL,3
                        ADD BX,24       ;Convertendo a posição da coluna para char
                        CMP CX,BX      
                    JNL COLUNABOTAO

                    ADD AL,1
                    XOR BX,BX 
                    MOV DH,AH
                    MOV DL,AL

                    MOV AH,02           ;Movendo o cursor para posição convertida( o cursor se move por char)  
                    int 10h
                CALL coloca_valor       ;função de colocar valor na tabela 
                CALL confere_vitoria    ;Função de checar se o sudoku está certo
                CMP flag,1
                JE FIM                  ;Se o sudoku estiver certo, pular para o fim
            JMP CONTROLE
 

        FIM:            ;fim do programa

        mov ax, 3        ;clear screen
        int 10h

        XOR DX,DX
        PUSH DX
        
        LEA SI,matriz
        CALL imprimematriz
        
        MOV AH,4CH
        int 21h
    


    MOV AH,4ch
    int 21h

    main endp


    ;=== Procedimento de imprimir grade do sudoku ===
    
    grade proc
        reg_push


        MOV Ah,0CH             ;Definindo começo da grade 
        XOR BX,BX
        MOV AL,1
        MOV DX,36
        MOV CX,214

        PROXPIXELINHAS:         ;Imprimindo as linhas das grade
            PIXELLINHAS:
                int 10h
                inc CX
                CMP CX,430      ;Imprime o pixel até a coluna 430
            JLE PIXELLINHAS
            MOV Al,9
            inc BL         
            ADD DX,16           ;Vai para o próxima linha até (DX = 180)
            MOV CX,214
            CMP BL,3
            JNE TROCACOR
                MOV AL,1        ;Muda de cor para a terceira,sexta e nona linha
                XOR BX,BX
            TROCACOR:
            CMP DX,180
        JLE PROXPIXELINHAS      

        MOV DX,36             
        MOV CX,214 
        XOR BX,BX
        MOV AL,1


        PROXPIXELCOL:            ;Imprimindo as colunas da grade 
            PIXELCOL:
                int 10h
                inc DX           ;A imprime a linha até o pixel 180
                CMP DX,180
            JLE PIXELCOL
            MOV AL,9
            inc BL
            ADD CX,24
            MOV DX,36              ;Próxima coluna (até CX = 430)
            CMP BL,3
            JNE TROCACORCOL
                MOV AL,1         ;Muda de cor para a terceira,sexta e nona coluna
                XOR BX,BX
            TROCACORCOL:
            CMP CX,430
        JLE PROXPIXELCOL

            reg_pop
            ret

    grade endp

     ;=== Procedimento de imprimir matriz 9x9 ===
    ;Imprime uma matriz 9x9 dando 2 espacos para cada coluna e 1 espaco para cada linha 
    ;Entrada:
    ;SI: Endereço da matriz 
    ;DL: Coluna do cursor
    ;DH: linha do cursor
    ;BH: página
    ;Na função:
    ;BL define a cor do texto
    ;DL = números de colunas impressas antes de pular para a próxima linha
    ;Dh = Linha atual

    imprimematriz proc

        reg_push                ;Push registradores
        CLD
        MOV BL,14


        MOV CX,9                ;Contador de linha 


        IMPRIME_LOOP:
            MOV AH,02
            int 10h             ;Posiciona o cursor(Linha DH,Coluna 39)
            ADD DH,2
            PUSH DX
    
            MOV DL,9            ;BL contador de coluna
            PROXLINHA:
                imp_espaco
                imp_espaco
                LODSB           ;Armazena dado da matriz em al       
                mov ah,0Eh   
                int 10h
                
                DEC DL
                CMP DL,0
            JNE PROXLINHA       ;Acaba quando todas as colunas da linha forem impressas
            POP DX
        LOOP IMPRIME_LOOP       ;Acaba quando todas as linhas da matriz forem impressas

        reg_pop

        ret


    imprimematriz endp


    
    ;=== Procedimento de colocar numero na matriz ===
    ;Coloca um valor de 1 a 9 (leitura) na matriz de acordo com a posição em que o cursor está
    ;Entrada:
    ;BH = página
    ;Cursor posicionado no valor que será substituído
    ;vetor_aux com 60 espaços


    coloca_valor proc

        reg_push

        MOV AH,03h         ;Pegando posição do cursor
        int 10h

        XOR AX,AX

        MOV AL,DH          ;Tranformando a linha  do cursor em coordenada da matriz
        SUB AL,5
        MOV CL,2
        DIV CL
        MOV CL,9
        MUL CL

        MOV BX,AX
        XOR AX,AX

        MOV AL,DH          ;Tranformando a coluna do cursor em coordenada da matriz
        MOV AL,Dl           
        SUB AL,1Ch
        MOV CL,3
        DIV CL
        MOV SI,AX

        XOR DI,DI
        VALIDACAOPOSICAO:            ;Verificando se o valor não é um valor imutável
            CMP BX,vetor_val[DI]
            JNE POSDIFERENTE         ; verifica se o endereço do valor não esta em vetor aux
            ADD DI,2
            CMP SI,vetor_val[DI]
            JNE POSDIFERENTE2
            JMP FIMCOLOCAVALOR
        POSDIFERENTE:
        ADD DI,2
        POSDIFERENTE2:
        ADD DI,2
        CMP DI,120
        JNE VALIDACAOPOSICAO


        MOV AH,02
        MOV Dl,2Dh         ;imprimindo "-"
        int 21h
    
        
        
        imp_back
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

FIMCOLOCAVALOR:
        reg_pop                 ;Recuperando valores iniciais
        

        ret 

    coloca_valor endp


    confere_vitoria proc
    ;=== Procedimento de conferir se o usuário completou o sudoku ==
    ;Realiza teste se a matriz está completa, se todas as linhas tem números diferentes
    ;se todas as colunas tem números diferentes e se as matrizes 3x3 tem números diferentes 
    ;Entrada: 
    ;vetor_aux com valor: '1','2','3','4','5','6','7','8','9'
    ;Saída:
    ;variável flag 0 ou 1 (0 = não ganhou 1 = usuário ganhou)
        reg_push
        
        XOR BX,BX
        XOR AX,AX
        MOV CX,81
        JMP TESTECOMPLETA          ;Testa se a matriz tem um espaço (' ')
        SHORTCUT2:
        JMP INVALIDOINCONPLETA     ;Se matriz tiver um espaço retornar flag = 0 (não ganhou o jogo)
        TESTECOMPLETA:
            MOV AL,matriz[BX]  
            CMP AL,20h
            JE SHORTCUT2
            INC BX
        LOOP TESTECOMPLETA

        XOR BX,BX
        MOV SI,-1
        MOV CX,9

        TESTELINHA:                         ;Teste de linha com o vetor aux
            PUSH CX             
            MOV CX,9
            LINHAMATRIZ:
                MOV AL,matriz[BX]           
                COMPARAVETOR:               ;Testar para cada linha da matriz   
                    CMP SI,9 
                    JE SHORTCUT
                    inc SI
                    CMP vetor_aux[SI],AL   ;Se o número for igual ao do vetor aux, transforma aquele número de vetor auxiliar em 0
                    JNE COMPARAVETOR       ;Se nenhum número for igual ao do vetor aux, usuário não ganhou o jogo
                    MOV vetor_aux[SI],0   
                    inc BX
                    MOV SI,-1
            LOOP LINHAMATRIZ 
            CALL restaura_vetoraux        ;Restaura o valor padrão do vetor
            POP CX

        LOOP TESTELINHA
        
        XOR AX,AX
        XOR BX,BX
        XOR DI,DI
        MOV SI,-1
        MOV CX,9

        TESTECOLUNA:                        ;Teste de coluna com o vetor aux
            PUSH CX
            MOV CX,9
            COLUNAMATRIZ:
                MOV AL,matriz[BX][DI]       ;Testar para cada linha da matriz   
                COMPARAVETORC:
                    CMP SI,9
                    JE SHORTCUT
                    inc SI
                    CMP vetor_aux[SI],AL        ;Se o número for igual ao do vetor aux, transforma aquele número de vetor auxiliar em 0                                 
                    JNE COMPARAVETORC           ;Se nenhum número for igual ao do vetor aux, usuário não ganhou o jogo
                    MOV vetor_aux[SI],0   
                    ADD BX,9
                    MOV SI,-1
            LOOP COLUNAMATRIZ 
            inc DI
            XOR BX,BX
            CALL restaura_vetoraux              ;Restaura o valor do vetor aux
            POP CX

        LOOP TESTECOLUNA

        
        XOR DX,DX
        XOR AX,AX
        XOR BX,BX
        MOV DI,0
        MOV SI,-1
        MOV CX,9
        TESTE3x3:                     ;Teste de matriz 3x3 com vetor aux
            PUSH CX
            MOV CX,9
            PROXMATRIZ3X3:
                MOV AL,matriz[BX][DI]
                COMPARAMATRIZM:
                SHORTCUT:
                    CMP SI,9
                    JE INVALIDO
                    inc SI
                    CMP vetor_aux[SI],AL        ;Se o número for igual ao do vetor aux, transforma aquele número de vetor auxiliar em 0
                    JNE COMPARAMATRIZM          ;Se nenhum número for igual ao do vetor aux, usuário não ganhou o jogo
                    MOV vetor_aux[SI],0   
                    inc DI
                    inc AH                     ;Ah = contador de linhas da matriz 3x3
                    MOV SI,-1
                    CMP AH,3 
                    JNE CONTINUA_LINHA         ;Ir para para próxima matrix 3x3 da coluna
                        XOR DI,DI
                        ADD BX,9
                        XOR AX,AX
                        MOV AL,DL
                        ADD DI,AX
                        XOR AX,AX
                    CONTINUA_LINHA:
            LOOP PROXMATRIZ3X3
            inc DH                       ;Contador de matrizes 3x3 da coluna
            CMP DH,3
            JNE PROXIMACOLUNA3            ;Posicionameto de matriz 3x3,ir para a próxma coluna de matriz 3x3
                XOR AX,AX
                ADD DL,3
                MOV AL,DL
                MOV DI,AX
                XOR AX,AX
                XOR BX,BX
                XOR DH,DH
            PROXIMACOLUNA3:
            CALL restaura_vetoraux        ;Restaura valor do vetor aux 
            POP CX

        LOOP TESTE3x3


        reg_pop
        MOV flag,1                         ;Flag = 1 (se o usuário ganhou)
        ret
        INVALIDO:
            POP CX
        INVALIDOINCONPLETA:
            CALL restaura_vetoraux        ;Flag = 0 (se o sudoku está errado/incompleto)
            reg_pop
            MOV flag,0
            ret

    confere_vitoria endp


    ;=== Procedimento de restaurar valor da vetor aux ===
    ;Restaura o valor original do vetor aux (1,2,3...9)
    ;Entrada:
    ;Vetor_aux
    restaura_vetoraux proc              
        reg_push

        XOR BX,BX                    
        MOV AL,31h
        restauracao:              ;Atribui o numero para o vetor
            MOV vetor_aux[BX],AL
            inc AL                 ;Al = número atribuido
            inc BX
        cmp BX,9
        jne restauracao

        reg_pop
        ret

    restaura_vetoraux endp

    ;=== Procedimento de valores imutaveis ===
    ;Define quais valores são imutaveis e armazena seu endereço no vetor_val
    ;Entrada:
    ;vetor_val (60 espacos)
    ;matriz 9x9
    valores_imutaveis proc
        reg_push

        MOV CX,9
        XOR BX,BX
        MOV DI,-1 
        XOR SI,SI
        
        
        PEGAVALORES:                            

            PROXLINHAVAL:
                inc DI
                CMP DI,9
                JE LINHACOMPLETA
                CMP MATRIZ[BX][DI],' '         ;Verifique se tem espaço no elemento(valor mutavel)
            JE PROXLINHAVAL
                MOV vetor_val[SI],BX           ;COloca a linha do valor imutavel no vetor val
                ADD SI,2          
                MOV vetor_val[SI],DI           ;Coloca a coluna do valor imutavel no vetor val
                ADD SI,2
            JMP PROXLINHAVAL
            LINHACOMPLETA:
            MOV DI,-1                          ;Reseta as colunas
            ADD BX,9                           ;Muda para a próxima linha
        LOOP PEGAVALORES


        reg_pop
        ret 
    valores_imutaveis endp

    ;=== Procedimento de atribuir valor para matriz principal
    ;Atribui uma matriz 9x9 para a matriz principal
    ;Entrada: 
    ;Matriz 9x9 principal
    ;SI = lea de Matriz 9x9
    atribui_matriz proc
    reg_push

    CLD 
    XOR BX,BX
    MOV CX,81
    loop_atribuicao:
        LODSB
        MOV matriz[BX],AL
        inc BX
    LOOP loop_atribuicao

    reg_pop
    ret
    atribui_matriz endp

    END MAIN




