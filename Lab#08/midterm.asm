ORG     0000H
AJMP    MAIN
ORG     0050H

MAIN:   
        MOV     P0,#0 //清除P0接口
        MOV     P3,#0 //清除P3接口
        ACALL   DELAY
        ACALL   CGRAM
        MOV     A, #00111000B //8BIT,2ROW,5X7
        ACALL   COMMAND //寫入指令
        MOV     A, #00001100B //DISPLAY DDRAM,CURSOR,BLINK
        ACALL   COMMAND //寫入指令
        MOV     A, #00000001B //清除顯示
        ACALL   COMMAND //寫入指令
        MOV     A, #10000000B //把AC設給DDRAM
        ACALL   COMMAND //寫入指令
        MOV     DPTR, #BEGIN
        MOV     R0, #0

START: 
    CLR     A
    MOV     A, R0
    MOVC    A, @A+DPTR
    CJNE    A, #14, DISPLAY
    MOV     A, #00000001B //清除顯示
    ACALL   COMMAND //寫入指令
    MOV     A, #10000000B //把AC設給DDRAM
    ACALL   COMMAND //寫入指令
    AJMP    LOOP
DISPLAY:
    ACALL   SEND
    INC     R0
    AJMP    START
        

LOOP:   
        //P1只看前4位 0在哪裡就是哪行
        MOV     P1, #01111111B //從第一行開始
        MOV     A, P1 //看現在要輸出的數字是多少

        //12
        CJNE    A, #01110111B, NEXT_0 //從最下面一列開始檢查
NEXT_0:  
        CJNE    A, #01111110B, NEXT_13 //換到最上面一列
        //AJMP    M1

NEXT_13:  
        MOV     P1, #10111111B //換到第二行
        MOV     A, P1
        CJNE    A, #10111110B, NEXT_14 //從最下面一列開始檢查
        AJMP    M2

NEXT_14:  
        MOV     P1, #11011111B //換到第三行
        MOV     A, P1
        CJNE    A, #11010111B, NEXT_2 //從最下面一列開始檢查
        //AJMP    ENTER
NEXT_2:  
        CJNE    A, #11011110B, NEXT_15 //換到最上面一列
        //AJMP    M3

NEXT_15:  
        MOV     P1, #11101111B //換到第四行
        MOV     A, P1
        CJNE    A,#11100111B, NEXT_3 //從最下面一列開始檢查
        AJMP    MAIN
NEXT_3:  
        CJNE    A, #11101110B, NEXT_NO //換到最上面一列
        AJMP    M4

NEXT_NO:  
        AJMP LOOP
        

M2:
    //顯示第一個圖案
        MOV     A, #10000000B
        ACALL   COMMAND //寫入指令
        MOV     A, #00H
        ACALL   SEND //寫入資料
        ACALL   POSTPONE

        //顯示第二個圖案
        MOV     A, #10000000B
        ACALL   COMMAND //寫入指令
        MOV     A, #01H
        ACALL   SEND //寫入資料
        ACALL   POSTPONE

        //顯示第三個圖案
        MOV     A, #10000000B
        ACALL   COMMAND //寫入指令
        MOV     A, #02H
        ACALL   SEND //寫入資料
        ACALL   POSTPONE
        AJMP    LOOP

M4:
    MOV R2, #2
    MOV A, #10000000B
    ACALL COMMAND
    MOV A, #00H
    ACALL SEND
    ACALL POSTPONE
    AJMP LOOP


//傳指令到Data Bus -> Instruction Register
COMMAND:   
        MOV     P0, A
        MOV     P3, #00000100B   //ENABLE,WRITE,IR
        ACALL   DELAY
        MOV     P3, #00000000B   //DISABLE,WRITE,IR
        ACALL   DELAY
        RET

SEND:   
        MOV     P0, A
        MOV     P3, #00000101B   //ENABLE,WRITE,DR
        ACALL   DELAY
        MOV     P3, #00000001B   //DISABLE,WRITE,DR
        ACALL   DELAY
        RET

//小延遲
DELAY:  
        MOV     R6, #0FFH
DELAY1:    
        MOV     R7, #0FFH
DELAY2:    
        DJNZ    R7, DELAY2
        DJNZ    R6, DELAY1
        RET

//大延遲
POSTPONE:  
        MOV     R1, #10
POSTPONE1:    
        ACALL   DELAY
        DJNZ    R1, POSTPONE1
        RET

//設定CGRAM位置
CGRAM:   
        MOV     A, #01000000B //把AC設給CGRAM
        ACALL   COMMAND //寫入指令
        CJNE  R2, #2, MMO4
        MOV     DPTR, #MODE2 //把動畫的Table存到DPTR的位置
        MOV     R0, #0 //從第0列開始印

//傳資料到CGRAM
SEND_C:    
        MOV     A, R0
        MOVC    A, @A+DPTR
        ACALL   SEND //寫入資料
        INC     R0
        CJNE    R0, #16, SEND_C
        RET
        
MMO4:
    MOV DPTR, #MODE4
    MOV R0, #0
SSEN:
    MOV A, R0
    MOVC A, @A+DPTR
    ACALL SEND
    INC R0
    CJNE R0, #52, SSEN
    RET


BEGIN:
    DB  "Choose a mode!", 14

MODE2:
    DB 11100B
    DB 10010B
    DB 10001B
    DB 10001B
    DB 10001B
    DB 10010B
    DB 11100B

    DB 11111B
    DB 11111B
    DB 10001B
    DB 10001B
    DB 10001B
    DB 10001B
    DB 10001B

    DB 00011111B
    DB 00011111B
    DB 00011111B
    DB 00010000B
    DB 00010000B
    DB 00010011B
    DB 00010001B
    DB 00010001B

MODE4:
    DB 11111B
    DB 11111B
    DB 11111B
    DB 11111B
    DB 11111B
    DB 11111B
    DB 11111B
    DB 11111B

END