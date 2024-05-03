ORG     0000H
AJMP    MAIN
ORG     0050H

MAIN:   
        MOV     DPTR, #NUM

LOOP:   
        MOV     R0, #0FFH
        //P1只看前4位 0在哪裡就是哪行
        MOV     P1, #01111111B //從第一行開始
        MOV     A, P1 //看現在要輸出的數字是多少

        //12
        CJNE    A, #01110111B, NEXT_8 //從最下面一列開始檢查
        MOV     R0, #2  //個位數是2
        AJMP    OUT2 //十位數是1
NEXT_8:  
        CJNE    A, #01111011B, NEXT_4 //換到倒數第二列
        MOV     R0, #8
        AJMP    OUT
NEXT_4:  
        CJNE    A, #01111101B, NEXT_0 //換到倒數第三列
        MOV     R0, #4
        AJMP    OUT
NEXT_0:  
        CJNE    A, #01111110B, NEXT_13 //換到最上面一列
        MOV     R0, #0
        AJMP    OUT


NEXT_13:  
        MOV     P1, #10111111B //換到第二行
        MOV     A, P1
        CJNE    A, #10110111B, NEXT_9 //從最下面一列開始檢查
        MOV     R0, #3 //個位數是3
        AJMP    OUT2 //十位數是1
NEXT_9:  
        CJNE    A, #10111011B, NEXT_5 //換到倒數第二列
        MOV     R0, #9
        AJMP    OUT
NEXT_5:  
        CJNE    A, #10111101B, NEXT_1 //換到倒數第三列
        MOV     R0, #5
        AJMP    OUT
NEXT_1:  
        CJNE    A, #10111110B, NEXT_14 //換到最上面一列
        MOV     R0, #1
        AJMP    OUT

NEXT_14:  
        MOV     P1, #11011111B //換到第三行
        MOV     A, P1
        CJNE    A, #11010111B, NEXT_10 //從最下面一列開始檢查
        MOV     R0, #4
        AJMP    OUT2
NEXT_10:  
        CJNE    A, #11011011B, NEXT_6 //換到倒數第二列
        MOV     R0, #0
        AJMP    OUT2
NEXT_6:  
        CJNE    A, #11011101B, NEXT_2 //換到倒數第三列
        MOV     R0, #6
        AJMP    OUT
NEXT_2:  
        CJNE    A, #11011110B, NEXT_15 //換到最上面一列
        MOV     R0, #2
        AJMP    OUT

NEXT_15:  
        MOV     P1, #11101111B //換到第四行
        MOV     A, P1
        CJNE    A,#11100111B, NEXT_11 //從最下面一列開始檢查
        MOV     R0,#5
        AJMP    OUT2
NEXT_11:  
        CJNE    A, #11101011B, NEXT_7 //換到倒數第二列
        MOV     R0, #1
        AJMP    OUT2
NEXT_7:  
        CJNE    A, #11101101B, NEXT_3 //換到倒數第三列
        MOV     R0, #7
        AJMP    OUT
NEXT_3:  
        CJNE    A, #11101110B, NEXT_NO //換到最上面一列
        MOV     R0, #3
        AJMP    OUT

NEXT_NO:  
        MOV     P0, #0FFH

OUT:    
        MOV     P2, #00000111B
        MOV     A, R0
        MOVC    A, @A+DPTR
        MOV     P0, A
        ACALL   DELAY
        AJMP    LOOP

//兩位數數字顯示
OUT2:   
        MOV     R3, #5

L1:     
        //十位數
        MOV     P2, #00001011B
        MOV     A, #01 //因為十位數一定是1 所以直接把1輸入至A
        MOVC    A, @A+DPTR
        MOV     P0, A
        ACALL   POSTPONE
        //個位數
        MOV     P2, #00000111B
        MOV     A, R0 //看現在按的按鈕的個位數是多少
        MOVC    A, @A+DPTR
        MOV     P0, A
        ACALL   POSTPONE
        DJNZ    R3, L1
        AJMP    LOOP


DELAY:  
        MOV     R5, #0FFH
DELAY1: 
        MOV     R6, #0FFH
DELAY2: 
        DJNZ    R6, DELAY2
        DJNZ    R5, DELAY1
        RET
POSTPONE:  
        MOV     R5, #0FFH
POSTPONE1:   
        DJNZ    R5, POSTPONE1
        RET

//七段顯示器的數字表
NUM:    
        DB 1000000B; //0
        DB 11111001B; //1
        DB 10100100B; //2
        DB 10110000B; //3
        DB 10011001B; //4
        DB 10010010B; //5
        DB 10000010B; //6
        DB 11111000B; //7
        DB 10000000B; //8
        DB 10011000B; //9
END