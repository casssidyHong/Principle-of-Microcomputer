AJMP START
ORG 0050H

START :
    MOV R0,#0
    MOV R1,#00001000B
    MOV DPTR,#LG
    AJMP LOOP

LOOP:
    MOV P3,#0
    MOV A,R0
    MOVC  A,@A+DPTR 
    MOV P2,A 
    MOV P3,R1
    INC R0

    MOV A,R1
    RL A
    MOV R1,A
    
    ACALL DELAY
    CJNE R0,#5,LOOP
    AJMP START

DELAY:
    MOV  R5, #0FFH//11111111
DELAY1: 
    DJNZ  R5,DELAY1
    RET
LG:
    DB 00000100B
    DB 00110010B
    DB 00000001B
    DB 00110010B
    DB 00000100B

END