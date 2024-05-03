ORG     0000H
AJMP    MAIN
ORG     0050H

MAIN:   
        MOV     P1,#0 //清除P1接口
        MOV     P2,#0 //清除P2接口
        ACALL   DELAY
        MOV     A, #00111000B //8BIT, 2ROW, 5X7
        ACALL   COMMAND //寫入指令
        MOV     A, #00001111B //DISPLAY DDRAM, CURSOR, BLINK
        ACALL   COMMAND //寫入指令
        MOV     A, #00000001B //清除顯示
        ACALL   COMMAND //寫入指令
        MOV     A, #10000000B //DDRAM歸0
        ACALL   COMMAND //寫入指令
        MOV     DPTR, #STUDENT_ID //把寫好的Table移到DPTR的位置
        MOV     R0, #0 //從學號的第一位開始顯示

LOOP:   
        CLR     A //清除A
        MOV     A, R0 
        MOVC    A, @A+DPTR //將學號的第A(R0)位數字輸入A
        CJNE    A, #8, NEXT //如果不是第8位數, 則跳轉到NEXT(因為學號有8位)
        AJMP    $
NEXT:   
        ACALL   SEND
        //R0+1再跳回回圈, 以顯示下一位的學號
        INC     R0              
        AJMP    LOOP

//傳指令到Data Bus -> Instruction Register
COMMAND:   
        MOV     P1, A
        MOV     P2, #00000100B   //ENABLE,WRITE,IR
        ACALL   DELAY
        MOV     P2, #00000000B   //DISABLE,WRITE,IR
        ACALL   DELAY
        RET

//傳資料到Data Bus -> Data Register
SEND:  
        MOV     P1,A
        MOV     P2, #00000101B   //ENABLE, WRITE, DR
        ACALL   DELAY
        MOV     P2, #00000001B   //DISABLE, WRITE, DR
        ACALL   DELAY
        RET

// 延遲
DELAY:  
        MOV     R5, #080H
DELAY1:    
        MOV     R6, #080H
DELAY2:    
        DJNZ    R6, DELAY2
        DJNZ    R5, DELAY1
        RET

STUDENT_ID:    
        DB      "Press 2 numbers", 8
        END