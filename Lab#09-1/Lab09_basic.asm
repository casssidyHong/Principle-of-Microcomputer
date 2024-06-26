ORG     0000H  
AJMP    MAIN
ORG     0050H

MAIN:   
    MOV     P3, #0FFH
    JNB     P3.2, DSP //外部中斷
    AJMP    MAIN

DSP:    
    MOV     DPTR, #WORD //把要顯示的Table移到DPTR的位址
    MOV     R0, #0 //從第一個數值開始顯示

/* 目標:
   讓側邊亮 所以P0,P1不動 動P2,P4
   -> 兩個byte為一組
      第一個byte輸出給P2, 第二個byte給P4 */
LOOP:    
    //第一個byte輸出給P2
    MOV     A, R0
    MOVC    A, @A+DPTR
    MOV     P2, A //顯示第一個數值

    //第二個byte輸出給P4
    INC     R0 //R0+1 換下一個數值
    MOV     A, R0 
    MOVC    A, @A+DPTR
    MOV     0C0H, A  //0C0H = P4

    INC     R0
    ACALL   DELAY
    CJNE    R0, #128, LOOP //Table內容數值共有 8*4*4 = 128
    AJMP    MAIN //輸完所有Table之後回到初始狀態, 重新輸出

//延遲
DELAY:  
    MOV     R6, #002H
DLAY2:  
    MOV     R5, #0F0H
DLAY1:  
    DJNZ    R5, DLAY1
    DJNZ    R6, DLAY2
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