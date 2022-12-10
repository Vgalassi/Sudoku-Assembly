TITLE Gabriel Hideki Yamamoto 22003967 Vinicius Henrique Galassi 22005768
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

    matriz_maker  db 9 dup (' ')
            db 9 dup (' ')
            db 9 dup (' ')
            db 9 dup (' ')
            db 9 dup (' ')
            db 9 dup (' ')
            db 9 dup (' ')
            db 9 dup (' ')
            db 9 dup (' ')    
    


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

    main_msg db 'SUDOKU DO HEXA$'
    maker_msg db 'CRIACAO DE SUDOKU(max 30 num)$'
    controle_msg db 'Controles:$'
    voltar_msg db 'Voltar$'
    clique_msg db 'Para por valores',10,20h,'na tabela,clique',10,20h,'no espaco e digite',10,20h,'um valor entre 1 a 9$'
    fim_msg db 'Pressione qualquer tecla para continuar$'
    Hexa db "HEXA<3$"
    FraseVitoria db "PARABENS VOCE TROUXE O HEXA PARA O BRASIL$" 
    INICIOMSG db "Bem Vindo ao SUDOKU DO HEXA$"
    OPCOES db "ESCOLHA ENTRE OS JOGOS ABAIXO$"
    OP1    db "JOGO 1                     (1)   JOGO 2                    (2)$" 
    OP2    db "JOGO PERSONALIZADO         (3)   CRIAR JOGO PERSONALIZADO  (4)$"
    OP3    db "SAIR DO JOGO               (5)$"
    OP4    db "PENTA$"   

    flag db '?'           ;flag para verificar se o usuario ganhou
    flag_maker db 0       ;flag para verificar se o usuario esta no modo de criacao
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

        MOV AX,@data       ;Movendo data para ax,ds,es
        MOV DS,AX
        MOV ES,AX



inicio:
        MOV flag_maker,0        ;Restaurar flag maker e variaveis
        XOR BX,BX
        XOR AX,AX
        XOR DX,DX
        XOR SI,SI
        XOR CX,CX



        MOV Ah,0
        MOV al,0Eh            ;Ativando modo se vídeo VGA 640x200
        int 10h


        MOV AH,0BH
        MOV BH,0            ;Cor de fundo preto (bl = 0)
        MOV BL,0
        int 10h



        CALL TELAINICIAL    ;Procedimento de imprimir tela inicial

        ZERAVAL:
            MOV vetor_val[BX],' '       ;reinicializando vetor val
            ADD bx,2
        CMP BX,120
        JNE ZERAVAL

        XOR BX,BX

        
        MOV AH,07           ;Esperando leitura de controle
        int 21h

        PUSH AX
        MOV Ah,0
        MOV al,0Eh            ;Ativando modo se vídeo CGA 640x200
        int 10h

        MOV AH,0BH
        MOV BH,1            ;Seleção de paleta
        MOV BL,0
        int 10h
        POP AX

        CMP AL,31h          ;Se o usuario digitar 1, usar predefinicao 1
        JE pred1

        CMP AL,32h          ;Se o usuario digitar 2,usar predefinicao 2
        JE pred2

        CMP AL,33h          ;Se o usuario digitar 3, jogar jogo personalizado
        JE playmaker

        CMP AL,34h          ;Se o usuarui digitar 4, entrar no mode de criacao
        JE make

        CMP AL,35h          ;Se o usuario digitar 5, sair do programa
        JE FINAL 

        JMP inicio 

        pred1:
            LEA SI,matriz_pr1       ;atribuindo matriz pred 1 para a matriz principal
            JMP ATRIBUIR
        pred2:
            LEA SI,matriz_pr2       ;atribuindo a matriz pred 2 para a matriz principal
            JMP ATRIBUIR
        playmaker:
            LEA SI,matriz_maker       ;atribuindo a matriz maker para a matriz principal
            JMP ATRIBUIR
        make:
            LEA SI,matriz_maker
            MOV flag_maker,1       ;Se o modo de criacao for ativado, flag maker = 1
            MOV DH,5               ;Posição da matriz (linha 5,coluna 26)
            MOV DL,26
            MOV BH,0
            CALL imprimematriz
            CALL grade                ;procedimento de imprimir matriz e grade
            MOV AH,02
            MOV DH,1
            MOV DL,26
            MOV BH,0                    ;Posicionando cursor no meio superior (linha 1,coluna 26)
            int 10h
            Imprime_msg maker_msg       ;Imprimindo mensagem que indica mode criacao
            JMP pulaatribuição

        final:
            JMP PROG_FIM                ;Pular para o encerramento do programa
        

    ATRIBUIR:
        
        CALL atribui_matriz          ;Procedimento de atribuir matriz em SI para a matriz principal
    

        MOV AH,02
        MOV DH,1
        MOV DL,32
        MOV BH,0                    ;Posicionando cursor no meio superior (linha 1,coluna 32)
        int 10h

        Imprime_msg main_msg       ;Imprimindo "sudoku assembly"

pulaatribuição:

        MOV DL,5
        MOV BH,0
        int 10h
        Imprime_msg voltar_msg     ;Imprimindo msg/botao de voltar

              
        MOV DH,7              ;Posicionando curso na esquerda (linha 7,coluna 1)
        MOV DL,1
        int 10h

        Imprime_msg controle_msg

        ADD DH,2                    ;Para cada mensagem, mover o cursor para a próxima linha
        int 10h

        Imprime_msg clique_msg


        CMP flag_maker,1          ;Verificando se esta no modo criacao
        JE CONTROLE


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

                CMP CX,85
                JG GRADETEST
                CMP DX,15           ;Testando se o clique está no botão de voltar
                JG GRADETEST
                JMP inicio          ;Se estiver, voltar para o inicio


            GRADETEST:          ;Matriz começa a printar linha 5  coluna 26
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
                MOV AH,3             ;AH = linha em char
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
                CMP flag_maker,1
                JE CONTROLE
                CALL confere_vitoria    ;Função de checar se o sudoku está certo
                CMP flag,1
                JE FIM                  ;Se o sudoku estiver certo, pular para o fim
            JMP CONTROLE
 

        FIM:            ;fim do programa

        MOV Ah,0
        MOV al,0Eh            ;Ativando modo se vídeo CGA 640x200
        int 10h

        MOV AH,02
        MOV DH,6              ;Posicionando cursor no meio superior (linha 1,coluna 32)
        MOV DL,19
        MOV BH,0
        int 10h

        Imprime_msg FraseVitoria  

        MOV DH,10
        int 10h
        Imprime_msg fim_msg

        CALL BANDEIRA         ;Procedimento de imprimir bandeira 

        
        MOV DH,17              ;Posicionando cursor no meio superior (linha 17,coluna 36)
        MOV DL,36
        int 10h

        Imprime_msg Hexa        
        
        MOV AH,07             ;Aguardando o usuario pressione
        int 21h

        JMP inicio
    

    PROG_FIM:
    MOV AH,4ch              ;fim do programa 
    int 21h

    main endp



    ;=== Procedimento de imprimir grade do sudoku ===
    ;Imprime a grade do sudoku,alternando entre cores a cada 3 impressões 
    
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

        MOV DX,36              ;Reinicializando(DX = linha incial)(CX = coluna inicial)
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
            CMP CX,430          ;Imprime até a coluna 430
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

        CMP flag_maker,1           ;Verificando se está no modo criacao(pular etapa se nao estiver
        JNE VALIDACAOPOSICAO
        MOV DI,-1
        XOR CX,CX
            CONTANOTESPACO:
                CMP DI,81
                JE CONTAGEMFEITA
                INC DI
                CMP matriz_maker[DI],' '         ;Contando quanto caracteres não espaco tem na matriz
                JE CONTANOTESPACO
                inc CL
            JMP CONTANOTESPACO

            CONTAGEMFEITA:
                CMP CL,30                       ;Se tiver 30 nao deixar mais o usuario editar
                JE CONFEREESPACO
                JMP pulavalidacaopos

            CONFEREESPACO:
                CMP matriz_maker[BX][SI],' '    ;Se contador de numero = 30, mas espaco editado carrega um numero, deixar usuario editar
                JE FIMCOLOCAVALOR
                JMP pulavalidacaopos
        
        VALIDACAOPOSICAO:            ;Verificando se o valor não é um valor imutável
            CMP BX,vetor_val[DI]
            JNE POSDIFERENTE         ; verifica se o endereço do valor não esta em vetor aux
            ADD DI,2
            CMP SI,vetor_val[DI]
            JNE POSDIFERENTE2
            JMP FIMCOLOCAVALOR
        POSDIFERENTE:
        ADD DI,2
        POSDIFERENTE2:              ;Indo para o proximo endereco do vetor_val
        ADD DI,2
        CMP DI,120
        JNE VALIDACAOPOSICAO

        pulavalidacaopos:


        MOV AH,02
        MOV Dl,2Dh         ;imprimindo "-"
        int 21h
    
        
        
        imp_back
    NOTNUM:
        CMP AL,' '
        JE ESPACOIN
        MOV AH,07           ;Lendo o input (sem echo)
        int 21h
        CMP Al,31h          ;Verificando se o input é válido (de 1 a 9)
        JL NOTNUM
        CMP AL,39h
        JG NOTNUM

    ESPACOIN:
        XOR CX,CX
        MOV CL,AL

        MOV AH,02           ;Imprimindo o input
        MOV Dl,AL
        int 21h

        imp_back

        CMP flag_maker,1         ;Atribuir para a matriz maker se estiver no modo de criacao
        JE atribuipmaker
        
        MOV MATRIZ[bx][si],CL    ;Colocando o valor na matriz
        JMP FIMCOLOCAVALOR

    atribuipmaker:
        MOV matriz_maker[BX][SI],CL
        

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
    

    ;=== Procedimento de imprimir bandeira do Brasil ===
    ;Imprimi a bandeira do brasil na região inferior da tela
    ;Entrada:
    ;N/A
    BANDEIRA proc
    reg_push

    ;VERDE PROC

    ; draw pixel -coluna -linha  -cor

        mov ah,0CH
        mov cx,160
        mov dx,103
        mov al,2

    linhavertical1:                  ;Linha verde esquerda
        int 10h
        inc dx
        cmp dx,181
        jne linhavertical1

        
    ; draw pixel -coluna -linha  -cor

        mov ah,0CH
        mov cx,160
        mov dx,103
        mov al,2
    linhahorizontal1:                ;Linha verde superior
        int 10h
        inc cx
        cmp cx,467
        jne linhahorizontal1
    ; draw pixel -coluna -linha  -cor

        mov ah,0CH
        mov cx,160
        mov dx,180
        mov al,2
    linhahorizontal2:               ;Linha verde inferior
        int 10h
        inc cx
        cmp cx,467
        jne linhahorizontal2

    ; draw pixel -coluna -linha  -cor

        mov ah,0CH
        mov cx,467
        mov dx,103
        mov al,2                    ;Linha verde direita
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
        inc cx                                   ;Linha amarela inferior esquerda
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
        inc cx                        ;Linha amarela superior direita
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
        int 10h                                     ;Linha amarela superior direita
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
        int 10h                                     ;Linha amarela superior esquerda
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
        jne quadrado      ;Loop de imprimir quadrado

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


    reg_pop
    ret
    BANDEIRA endp

    TELAINICIAL proc               ;proc para iniciar a tela de vitória 
    
    reg_push
    
    ;640x200        
        MOV ah,00h                      ;iniciando o modo de video 
        MOV al,0eh                      ;
        int 10h                         ;


        MOV AH,02                       ;Posicionando cursor no meio superior (linha 1,coluna 32)
        MOV DH,2                        ;
        MOV DL,12                       ;
        MOV BH,0                        ;
        int 10h                         ;


        Imprime_msg INICIOMSG


        MOV AH,02                       ;Posicionando cursor no meio superior (linha 1,coluna 32)
        MOV DH,4                        ;
        MOV DL,12                       ;
        MOV BH,0                        ;
        int 10h                         ;

                                ;imprimindo msg de opcoes
       Imprime_msg OPCOES

        MOV AH,02                       ;Posicionando cursor no meio superior (linha 1,coluna 32)
        MOV DH,6                        ;
        MOV DL,12                       ;
        MOV BH,0                        ;
        int 10h                         ;

                                ;imprimindo msg de inicio
        Imprime_msg OP1

        MOV AH,02                       ;Posicionando cursor no meio superior (linha 1,coluna 32)
        MOV DH,8                        ;
        MOV DL,12                       ;
        MOV BH,0                        ;
        int 10h                         ;

                                ;imprimindo msg de inicio
        Imprime_msg OP2
        

        MOV AH,02                       ;Posicionando cursor no meio superior (linha 1,coluna 32)
        MOV DH,10                       ;
        MOV DL,12                       ;
        MOV BH,0                        ;
        int 10h                         ;

                                ;imprimindo msg de inicio
        Imprime_msg OP3                ;
        

    CALL BANDEIRA
    Imprime_msg OP4

    reg_pop
    ret

    TELAINICIAL endp

    ;=== Procedimento de atribuir valor para matriz principal
    ;Atribui uma matriz 9x9 para a matriz principal
    ;Entrada: 
    ;Matriz 9x9 principal
    ;SI = lea de Matriz 9x9
    atribui_matriz proc
    reg_push

    CLD 
    XOR BX,BX                   ;Loop de 81
    MOV CX,81
    loop_atribuicao:
        LODSB                   ;Armazenar em AL e percorrer a matriz 
        MOV matriz[BX],AL       ;Mover al para a matriz principal
        inc BX
    LOOP loop_atribuicao

    reg_pop
    ret
    atribui_matriz endp

    END MAIN




