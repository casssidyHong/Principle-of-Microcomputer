ORG     0000H
AJMP    MAIN
ORG     0050H

MAIN:   
        MOV     P2,#0 //清除P2接口
        MOV     P1,#0 //清除P1接口
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
        
/*目標: 一頁一頁顯示動畫(2個圖像), 
       每次先把cursor移到左上角讓LCM顯示後再寫入資料,
       不斷重複以達到動畫的效果*/
LOOP:   
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
        AJMP    LOOP

//傳指令到Data Bus -> Instruction Register
COMMAND:   
        MOV     P2, A
        MOV     P1, #00000100B   //ENABLE,WRITE,IR
        ACALL   DELAY
        MOV     P1, #00000000B   //DISABLE,WRITE,IR
        ACALL   DELAY
        RET

SEND:   
        MOV     P1, #00000101B   //ENABLE,WRITE,DR
        MOV     P2, A
        ACALL   DELAY
        MOV     P1, #00000001B   //DISABLE,WRITE,DR
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
        MOV     DPTR, #GRAPH //把動畫的Table存到DPTR的位置
        MOV     R0, #0 //從第0列開始印

//傳資料到CGRAM
SEND_C:    
        MOV     A, R0
        MOVC    A, @A+DPTR
        ACALL   SEND //寫入資料
        INC     R0
        /*因為動畫總共有兩個圖案, 每次都是8列, 一共16列,
          所以還沒有顯示完16列之前要一直循環這個迴圈*/
        CJNE    R0, #16, SEND_C
        RET
        
//小人在跑的圖案
GRAPH:    
        DB  10100B
        DB  10100B
        DB  11111B
        DB  00101B
        DB  01110B
        DB  01011B
        DB  11000B
        DB  11111B //地板

        DB  00101B
        DB  00101B
        DB  11111B
        DB  10100B
        DB  01110B
        DB  11010B
        DB  00011B
        DB  11111B //地板
        END