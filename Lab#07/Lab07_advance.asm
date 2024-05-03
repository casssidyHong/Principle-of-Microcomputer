ORG     0000H
AJMP    MAIN
ORG     0050H

MAIN:   
        MOV  R0 #10001000B //上下四位相同以確保旋轉可以連續

//沿用上次使用鍵盤改變七段顯示器顯示數字的邏輯, 從左下開始檢查 先往上再往右
//第一行 12->8->4->0
LOOP:    
        ACALL  DELAY               
        MOV  R1, #0              
        MOV  P1, #01111111B
        MOV  A, P1 //把按鈕信號輸入A

        //檢查當前被按下的按鈕是哪一個 -> 12
        CJNE  A, #5, NEXT_8
        MOV  R1, #5 //225/45 = 5
        AJMP  OUT //順時針轉

NEXT_8:  
        CJNE  A, #01111011B, NEXT_4
        MOV  R1, #1 //45/45 = 1
        AJMP  OUT //順時針轉
NEXT_4:  
        CJNE  A, #01111101B, NEXT_0
        MOV  R1, #5 //225/45 = 5
        AJMP  OUT2  //逆時針轉
NEXT_0:  
        CJNE  A, #01111110B, NEXT_14
        MOV  R1, #1 //45/45 = 1
        AJMP  OUT2 //逆時針轉

//第二行 13->9->5->1
NEXT_13:  
        MOV  P1, #10111111B
        MOV  A, P1
        CJNE  A, #10110111B, NEXT_9
        MOV  R1, #6 //270/45 = 6
        AJMP  OUT //順時針轉
NEXT_9:  
        CJNE  A, #10111011B, NEXT_5
        MOV  R1, #2 //90/45 = 2
        AJMP  OUT //順時針轉
NEXT_5:  
        CJNE  A, #10111101B, NEXT_1
        MOV  R1, #6 //270/45 = 6
        AJMP  OUT2 //逆時針轉
NEXT_1:  
        CJNE  A, #10111110B, NEXT_14
        MOV  R1, #2 //90/45 = 2
        AJMP  OUT2 //逆時針轉

//第三行 14->10->6->2
NEXT_14:  
        MOV  P1, #11011111B
        MOV  A, P1
        CJNE  A, #11010111B, NEXT_10
        MOV  R1, #7 //315/45 = 7
        AJMP  OUT //順時針轉
NEXT_10:  
        CJNE  A, #11011011B, NEXT_6
        MOV  R1, #3 //135/45 = 3
        AJMP  OUT //順時針轉
NEXT_6:  
        CJNE  A, #11011101B, NEXT_2
        MOV  R1, #7 //315/45 = 7
        AJMP  OUT2 //逆時針轉
NEXT_2:  
        CJNE  A, #11011110B, NEXT_15
        MOV  R1, #3 //135/45 = 3
        AJMP  OUT2 //逆時針轉

//第四行 15->11->7->3
NEXT_15:  
        MOV  P1, #11101111B //換到第四行
        MOV  A, P1
        CJNE  A, #11100111B, NEXT_11
        MOV  R1, #8 //360/45 = 8
        AJMP  OUT //順時針轉
NEXT_11:  
        CJNE  A, #11101011B, NEXT_7
        MOV  R1, #4 //180/45 = 4
        AJMP  OUT //順時針轉
NEXT_7:  
        CJNE  A, #11101101B, NEXT_3
        MOV  R1, #8 //360/45 = 8
        AJMP  OUT2 //逆時針轉
NEXT_3:  
        CJNE  A, #11101110B, NEXT_NO
        MOV  R1, #4 //180/45 = 4
        AJMP  OUT2 //逆時針轉

//這輪都沒有按鈕被按下, 重新檢查下一輪是哪個按鈕被按下
NEXT_NO:  
        AJMP  LOOP

//順時針轉
OUT:    
        ACALL  CW45
        DJNZ  R1, OUT
        AJMP  LOOP
//逆時針轉
OUT2:   
        ACALL  CCW
        DJNZ  R1, OUT2
        AJMP  LOOP
        
//因為題目要求的都是45的倍數, 所以把45設成一個單位
//順時針
CW45:    
        MOV  R7, #64          
ClockWise:     
        //因為順時針是向右轉, 所以讓R0向右移一個
        XCH  A, R0
	RR  A
	XCH  A, R0

        MOV  P0, R0
        ACALL  DELAY
        DJNZ  R7, ClockWise
        RET
//逆時針
CCW45:    
        MOV  R7, #64            
CounterClockWise:   
        //因為逆時針是向左轉, 所以讓R0向左移一個
        XCH  A, R0
  	RL  A
	XCH  A, R0

        MOV  P0, R0
        ACALL  DELAY
        DJNZ  R7, CounterClockWise
        RET

//延遲
DELAY:  
        MOV  R5, #0FFH
DELAY1: 
        MOV  R6, #07FH
DELAY2: 
        DJNZ  R6, DELAY2
        DJNZ  R5, DELAY1
        RET
        END