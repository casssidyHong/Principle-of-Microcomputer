ORG     0000H  
AJMP    MAIN
ORG     0003H
AJMP    ITR //中斷副程式的入口
ORG     0050H //新的起始位址

//外部中斷的設定
MAIN:   
    SETB    IT0 //負源觸發 0的時候燈亮
    SETB    EX0 //外部中斷
    SETB    EA //全域中斷

//水平LED亮
LOOP1: 
    MOV     P0, #0
    MOV     P1, #0FFH
    AJMP    LOOP1

//中斷：內圈暗外圈亮
ITR : 
    MOV     P0, #0FFH 
    MOV     P1, #0 
    JMP   DISPLAY //顯示文字
    //RETI  //中斷的RETURN

//顯示文字
DISPLAY:
    MOV     DPTR, #WORD //把要顯示的Table移到DPTR的位址
    MOV     R1, #0 // 從第一個數值開始顯示
    MOV     R0, #0 //從第一個數值開始讀取

//側邊LED亮
LOOP2:    
    //第一個byte輸出給P2
    MOV     A, R1
    ADD     A, R0
    MOVC    A, @A+DPTR
    MOV     P2, A //顯示第一個數值       

    //第二個byte輸出給P4
    INC     R0 //R0+1 換下一個數值
    MOV     A, R1
    ADD     A, R0
    MOVC    A, @A+DPTR
    MOV     0C0H, A // 0C0H = P4

    INC     R0
    ACALL   DELAY
    CJNE    R0, #96, LOOP2 //Table內容數值共有 8*4*3 = 96

    //把燈關掉
    MOV     P2, #0FFH        
    MOV     0C0H, #0FFH   

    //下次顯示下一行, 又因為兩個byte為一組, 所以R1要+2
    INC     R1
    INC     R1
    RETI

//延遲
DELAY:  
    MOV     R6,#10
DLAY2:  
    MOV     R5,#40
DLAY1:  
    DJNZ    R5,DLAY1
    DJNZ    R6,DLAY2
    RET

//「別當我」table
WORD:
    DB  0FFH,07FH,0C1H,0BFH,0DDH,0CFH,05DH,0F0H
    DB  0DDH,0BDH,0DDH,07DH,0DDH,0BDH,0C1H,0C1H
    DB  0FFH,0FFH,0FFH,0FFH,007H,0F0H,0FFH,0BFH
    DB  0FFH,07FH,000H,080H,0FFH,0FFH,0FFH,0FFH

    DB  0DFH,0FFH,0E7H,0FFH,0F7H,003H,015H,0AAH
    DB  0D3H,0AAH,0D7H,0AAH,0D7H,0AAH,0D0H,082H
    DB  0D7H,0AAH,0D7H,0AAH,0D3H,0AAH,015H,0AAH
    DB  0F7H,003H,0D7H,0FFH,0E7H,0FFH,0FFH,0FFH

    DB  0DFH,0FFH,0DBH,0F7H,0DBH,0B7H,0DBH,07BH
    DB  001H,080H,0DCH,0FDH,0DDH,0BEH,0DFH,0BFH
    DB  0DFH,0DFH,000H,0ECH,0DFH,0F3H,0DDH,0EBH
    DB  0D3H,0DDH,05FH,0BEH,0DFH,007H,0FFH,0FFH
    
    END