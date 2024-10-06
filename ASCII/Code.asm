.MODEL SMALL

.Data
CONST16 DB 16
HEXSYM  DB '0123456789ABCDEF'
PATTERN DB 'XX-$' 
CODSYM  DB ?

.CODE
.STARTUP

MOV     AX, 40h
MOV     ES, AX

MOV     CODSYM, 0
MOV     CX, 16

PRTABLE:
    PUSH    CX  
    MOV     CX, 16  

    POVT:
        PUSH    CX

        MOV     AL, CODSYM

        MOV     AH, 0
        DIV     CONST16
        MOV     BX,  Offset HexSym
        XLAT

        MOV     PATTERN, AL
        MOV     AL, AH
        XLAT
        
        MOV     PATTERN + 1, AL
        MOV     AH, 9
        LEA     DX, PATTERN
        INT     21h

        MOV     BH, 0
        MOV     BL, 0
        MOV     AH, 0Ah      
        MOV     AL, CODSYM   
        MOV     CX, 1
        INT     10h


        MOV     AH, 03
        INT     10h
        MOV     AH, 02
        ADD     DL, 2
        INT     10h
        INC     CODSYM

        POP     CX

        LOOP    POVT  

    POP     CX  

    MOV     AH, 0Eh         
    MOV     AL, 0Dh
    INT     10h                   
    MOV     AL, 0Ah                 
    INT     10h                  

LOOP    PRTABLE

MOV     AH, 4ch
INT     21h

END