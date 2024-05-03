NUM1 EQU R0

ORG 0000H
AJMP MAIN
ORG 0050H

MAIN:   
    MOV     DPTR, #NUM

//目標：從左下開始檢查 先往上再往右
//第一行 12->8->4->0
LOOP:   
    MOV NUM1, #0FFH  //255
    //P1只看前4位 0在哪裡就是哪行
    MOV     P1, #01111111B //從第一行開始
    MOV     A, P1 //看現在要輸出的數字是多少

    //12
    CJNE    A, #01110111B, NEXT_8 //從最下面一列開始檢查
    MOV     NUM1, #12 //個位數是2
    AJMP    OUT //十位數是1
NEXT_8:  
    CJNE A, #01111011B, NEXT_4 //換到倒數第二列
    MOV NUM1, #8
    AJMP OUT
NEXT_4:  
    CJNE A, #01111101B, NEXT_0 //換到倒數第三列
    MOV NUM1, #4
    AJMP OUT
NEXT_0:  
    CJNE A, #01111110B, NEXT_13 //換到最上面一列
    MOV NUM1, #0
    AJMP OUT
    
//第二行 13->9->5->1
NEXT_13:  
    MOV     P1, #10111111B //換到第二行
    MOV     A, P1
    CJNE    A, #10110111B, NEXT_9 //從最下面一列開始檢查
    MOV     NUM1, #13 //E
    AJMP    OUT
NEXT_9:  
    CJNE    A, #10111011B, NEXT_5 //換到倒數第二列
    MOV     NUM1, #9
    AJMP    OUT
NEXT_5:  
    CJNE    A,#10111101B, NEXT_1 //換到倒數第三列
    MOV     NUM1,#5
    AJMP    OUT
NEXT_1:  
    CJNE    A, #10111110B, NEXT_14 //換到最上面一列
    MOV     NUM1,#1
    AJMP    OUT

//第三行 14->10->6->2
NEXT_14:  
    MOV     P1, #11011111B //換到第三行
    MOV     A, P1
    CJNE    A, #11010111B, NEXT_10 //從最下面一列開始檢查
    MOV     NUM1, #14
    AJMP    OUT
NEXT_10:  
    CJNE    A, #11011011B, NEXT_6 //換到倒數第二列
    MOV     NUM1, #10
    AJMP    OUT
NEXT_6:  
    CJNE    A, #11011101B, NEXT_2  //換到倒數第三列
    MOV     NUM1, #6
    AJMP    OUT
NEXT_2:  
    CJNE    A, #11011110B, NEXT_15  //換到最上面一列
    MOV     NUM1,#2
    AJMP    OUT

//第四行 15->11->7->3
NEXT_15:  
    MOV     P1, #11101111B //換到第四行
    MOV     A, P1
    CJNE    A, #11100111B, NEXT_11  //從最下面一列開始檢查
    MOV     NUM1, #15
    AJMP    OUT
NEXT_11:  
    CJNE    A, #11101011B, NEXT_7  //換到倒數第二列
    MOV     NUM1, #11
    AJMP    OUT
NEXT_7:  
    CJNE    A, #11101101B, NEXT_3  //換到倒數第三列
    MOV     NUM1, #7
    AJMP    OUT
NEXT_3:  
    CJNE    A,#11101110B, NEXT_NO  //換到最上面一列
    MOV     NUM1,#3
    AJMP    OUT

//都沒有按按鍵
NEXT_NO:  
    MOV     P0, #0FFH   //no

//數字顯示
OUT:    
    MOV     P2, #00000111B
    MOV     A, NUM1
    MOVC    A, @A+DPTR
    MOV     P0, A
    ACALL   DELAY
    AJMP    LOOP

DELAY:  
    MOV     R5, #0FFH
DELAY1: 
    MOV     R6, #0FFH
DELAY2: 
    DJNZ    R6, DELAY2
    DJNZ    R5, DELAY1
    RET

NUM:    
    DB 1000000B //0
    DB 11111001B //1
    DB 10100100B //2
    DB 10110000B //3
    DB 10011001B //4
    DB 10010010B //5
    DB 10000010B //6
    DB 11111000B //7
    DB 10000000B //8
    DB 10011000B //9

    DB 10001000B //A
    DB 10000011B //b
    DB 11000110B //C
    DB 10100001B //d
    DB 10000110B //E 
    DB 10001110B //F
END