.model small

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


        MOV AH,00h
        MOV AL,6
        int 10h
   
        MOV AL,3
        int 10h

        MOV AH, 06h    
        XOR AL, AL     
        XOR CX, CX     
        MOV DX, 184FH  
        MOV BH, 70h
        int 10H

        MOV AH, 06h    
        XOR AL, AL     
        XOR CX, CX     
        MOV DL, 6
        MOV DH,24
        MOV BH,07
        int 10H

        MOV AH, 06h    
        XOR AL, AL     
        XOR CX, CX     
        MOV DL,80
        MOV DH,2
        MOV BH,07
        int 10H

        
        MOV AH, 06h    
        XOR AL,AL     
        MOV CH,3
        MOV CL,74
        MOV DH,21
        MOV DL,80
        MOV BH,07
        int 10H

        MOV AH, 06h    
        XOR AL,AL     
        MOV CH,22
        MOV CL,7
        MOV DH,24
        MOV DL,80
        MOV BH,07
        int 10H



        MOV AH,2 
        MOV DH,7
        MOV DL,18
        MOV BH,0
        int 10h 



  
    

        CALL imprimematriz
        
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





            
            
            