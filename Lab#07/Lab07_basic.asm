ORG     0000H
AJMP    MAIN
ORG     0050H

MAIN:   
	MOV  R0, #10001000B //上下四位相同以確保旋轉可以連續

// 逆時針轉90º
CCW90:    
	MOV  R7, #128 //設定參數讓馬達可以剛好轉90º
CounterClockWise:
	//因為逆時針是向左轉, 所以讓R0向左移一個
  	XCH  A, R0
  	RL  A
	XCH  A, R0

	MOV  P0, R0
	ACALL DELAY
	DJNZ  R7,CounterClockWise //重複直到轉了90º

// 順時針轉180º
CW45:    
	MOV  R7,#64 //因為剛好是90的一半, 所以直接拿上面找到的/2
ClockWise:
	//因為順時針是向右轉, 所以讓R0向右移一個
	XCH  A, R0
	RR  A
	XCH  A, R0

	MOV  P0, R0
	ACALL  DELAY
    DJNZ R7, ClockWise //重複直到轉了45º

// 延遲
DELAY:  
	MOV  R5,#0FFH
DELAY1: 
	MOV  R6,#0FFH
DELAY2: 
	DJNZ  R6,DELAY2
    DJNZ  R5,DELAY1
    RET
    END