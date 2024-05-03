//初始設定
ORG 0000H 
AJMP MAIN
ORG 0050H

MAIN:
  	MOV R3, #3D //記錄當前要顯示哪個字 共3個所以初始化為3

//延遲
DELAY3:
  	MOV R7, #0FFH 
DELAY4:
  	MOV R6, #005H 

//重新設置為左上角那個位置
RESET:
	MOV R0, #0D //顯示到哪一行
	MOV R1, #10000B //哪一顆亮

/*目標：
  用R3的數字決定現在要顯示哪個數,
  就把那個數的table移到DPTR中
  1. R3=3: 顯示「小」
  2. R3=2: 顯示「中」
  3. R3=1: 顯示「大」*/
WORD1:
	CJNE R3, #3, WORD2
	MOV DPTR, #SMALL //把SMALL的table移到DPTR
	AJMP LOOP
WORD2:
	CJNE R3, #2, WORD3 
	MOV DPTR, #MIDDLE //把MIDDLE的table移到DPTR
	AJMP LOOP
WORD3:
	MOV DPTR, #BIG //把BIG的table移到DPTR

LOOP:
	MOV P1, #0 //從第0列開始(i.e.最左邊)
	MOV A, R0 //當前在哪一行
	MOVC A, @A+DPTR 
	MOV P0, A  //把當行要亮的燈號輸出
	MOV P1, R1 	//看是亮哪一顆

	//呼叫"DELAY"副程式進行延遲
	ACALL DELAY

	//R1右旋一位
	XCH A, R1
	RR A
	XCH A, R1
	//R0+1 下次換看下一行
	INC R0

	//目標：跑完一整個點矩陣之後才換下一個數字
	CJNE R0, #5, LOOP

	//延遲完重新初始化成左上角那個點(RESET)
	DJNZ R6, RESET
	DJNZ R7, DELAY4 
	DJNZ R3, DELAY3
	AJMP MAIN

//延遲
DELAY:
  MOV  R5, #0FFH
DELAY1: 
  DJNZ  R5, DELAY1
  RET

//建立「大中小」的Table
BIG:
	DB 0100010B
	DB 0100100B
	DB 1111000B
	DB 0100100B
	DB 0100010B
MIDDLE:
	DB 0111110B
	DB 0100010B
	DB 1111111B
	DB 0100010B
	DB 0111110B
SMALL:
	DB 0111100B
	DB 0000001B
	DB 1111111B
	DB 0000000B
	DB 0111100B

END