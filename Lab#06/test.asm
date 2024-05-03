        ORG     0000H
        AJMP    INIT
        ORG     0050H
        
INIT:   MOV     DPTR,#SST
LOOP:   MOV     R0,#0FFH  //255
        MOV     P1,#01111111B //0111
        MOV     A,P1
        CJNE    A,#01110111B,NEXT1 //12
        MOV     R0,#12
        AJMP    OUT    
NEXT1:  CJNE    A,#01111011B,NEXT2 //8
        MOV     R0,#8
        AJMP    OUT
NEXT2:  CJNE    A,#01111101B,NEXT3 //4
        MOV     R0,#4
        AJMP    OUT
NEXT3:  CJNE    A,#01111110B,NEXT4 //0
        MOV     R0,#0
        AJMP    OUT
//
NEXT4:  MOV     P1,#10111111B //1011
        MOV     A,P1
        CJNE    A,#10110111B,NEXT5 //13
        MOV     R0,#13
        AJMP    OUT
NEXT5:  CJNE    A,#10111011B,NEXT6 //9
        MOV     R0,#9
        AJMP    OUT
NEXT6:  CJNE    A,#10111101B,NEXT7 //5
        MOV     R0,#5
        AJMP    OUT
NEXT7:  CJNE    A,#10111110B,NEXT8 //1
        MOV     R0,#1
        AJMP    OUT
//
NEXT8:  MOV     P1,#11011111B //1101
        MOV     A,P1
        CJNE    A,#11010111B,NEXT9 //14
        MOV     R0,#14
        AJMP    OUT
NEXT9:  CJNE    A,#11011011B,NEXTA //10
        MOV     R0,#10
        AJMP    OUT
NEXTA:  CJNE    A,#11011101B,NEXTB  //6
        MOV     R0,#6
        AJMP    OUT
NEXTB:  CJNE    A,#11011110B,NEXTC  //2
        MOV     R0,#2
        AJMP    OUT
//
NEXTC:  MOV     P1,#11101111B //1110
        MOV     A,P1
        CJNE    A,#11100111B,NEXTD  //15
        MOV     R0,#15
        AJMP    OUT
NEXTD:  CJNE    A,#11101011B,NEXTE  //11
        MOV     R0,#11
        AJMP    OUT
NEXTE:  CJNE    A,#11101101B,NEXTF  //7
        MOV     R0,#7
        AJMP    OUT
NEXTF:  CJNE    A,#11101110B,NEXTN  //3
        MOV     R0,#3
        AJMP    OUT
//
NEXTN:  MOV     P0,#0FFH   //no

OUT:    MOV     P3,#00001110B
        MOV     A,R0
        MOVC    A,@A+DPTR
        MOV     P0,A
        ACALL   DELAY
        AJMP    LOOP

L1:     
        MOV     P3,#00001110B
        MOV     A,R0
        MOVC    A,@A+DPTR
        MOV     P0,A
        ACALL   SDELAY
        DJNZ    R3,L1
        AJMP    LOOP

DELAY:  
    MOV     R5,#0FFH
DELAY1: 
    MOV     R6,#0FFH
DELAY2: 
    DJNZ    R6,DELAY2
    DJNZ    R5,DELAY1
    RET

SDELAY:  
    MOV     R5,#0FFH
SDE1:   
    DJNZ    R5,SDE1
    RET

SST:    
    DB 0F9H,092H,090H,0C6H//159C
    DB 0A4H,082H,0C0H,0A1H//260d
    DB 0B0H,0F8H,088H,086H//37AE
    DB 099H,080H,083H,08EH//48bF
END