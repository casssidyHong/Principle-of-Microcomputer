ORG     0000H
AJMP    MAIN //跳到MAIN
ORG     0003H
AJMP    ITR   //中斷副程式的入口
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
ITR:
    MOV     P0, #0FFH 
    MOV     P1, #0 
    ACALL   DISPLAY //顯示文字
    RETI  //中斷的RETURN

//顯示文字
DISPLAY:
    MOV     P3, #0FFH
    MOV     DPTR, #WORD //把要顯示的Table移到DPTR的位址
    MOV     R0, #0 //從第一個數值開始顯示

//側邊LED亮
LOOP2:    
    //第一個byte輸出給P2
    MOV     A, R0
    MOVC    A, @A + DPTR
    MOV     P2, A  //顯示第一個數值

    //第二個byte輸出給P4
    INC     R0 //R0+1 換下一個數值
    MOV     A, R0
    MOVC    A, @A + DPTR
    MOV     0C0H, A //0C0H = P4

    INC     R0
    ACALL   DELAY 
    CJNE    R0, #128, LOOP2 //Table內容數值共有 8*4*4 = 128
    RET 

//延遲
DELAY:
    MOV     R6, #002H
DELAY2:
    MOV     R5, #0F0H
DELAY1: 
    DJNZ    R5, DELAY1
    DJNZ    R6, DELAY2
    RET

//「我想放假」的Table
WORD: 
    DB 0FFH,0FFH,0BFH,0F7H,0B7H,0A7H,0B7H,0B7H
    DB 0B7H,037H,003H,080H,0BBH,0FBH,0BBH,0FBH
    DB 0BFH,07DH,0BFH,0BFH,001H,0D8H,0BDH,0E7H
    DB 0BFH,0DBH,0BBH,0BCH,0B7H,07EH,0A7H,00FH

    DB 0FFH,0FFH,0F7H,03EH,077H,08FH,097H,0FFH
    DB 001H,0FCH,0D5H,087H,037H,077H,077H,07EH
    DB 0FFH,077H,001H,06CH,0ABH,04EH,0ABH,07EH
    DB 0ABH,01EH,0ABH,0BEH,001H,0ECH,0FBH,09FH
	
    DB 0FFH,0FFH,0EFH,07FH,0EFH,09FH,00DH,0E0H
    DB 06BH,0BFH,063H,03FH,02FH,080H,06FH,0FFH
    DB 0EFH,07DH,07FH,07EH,081H,0BFH,06DH,0D8H
    DB 0EFH,0E7H,0EFH,0D8H,00FH,0BFH,0EFH,07FH

    DB 0FFH,0FFH,07FH,0FFH,0BFH,0FFH,00FH,000H
    DB 0F1H,0FFH,0FFH,0FFH,001H,000H,0DBH,0EDH
    DB 0DBH,0E4H,081H,0EDH,0FFH,07FH,0DBH,0B1H
    DB 0DBH,0CDH,0DBH,0EDH,081H,090H,0FBH,07DH

END