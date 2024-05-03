//初始設定
ORG 0000H 
AJMP MAIN
ORG 0050H

MAIN:
	MOV R0, #0D //顯示到哪一行
	MOV R1, #00000100B //哪一顆亮
	MOV DPTR, #SMALL //把SMALL的table移到DPTR

LOOP:
	MOV P3, #0 //從第0列開始(i.e.最左邊)
	MOV A, R0 //當前在哪一行
	MOVC A, @A+DPTR 
	MOV P2, A  //jpo5
	MOV P3, R1 	//jpo4
	//R0+1 下次換看下一行
	INC R0

	//呼叫"DELAY"副程式進行延遲
	ACALL DELAY

	//R1右旋一位
	XCH A, R1
	RL A
	XCH A, R1


	//目標：跑完一整個點矩陣之後才換下一個數字
	CJNE R0, #5, LOOP
	AJMP MAIN

//延遲
DELAY:
  MOV  R5, #0FFH
DELAY1: 
  DJNZ  R5, DELAY1
  RET

//建立「大中小」的Table
SMALL:
	DB 00100010B
	DB 00100100B
	DB 01111000B
	DB 00100100B
	DB 00100010B
END