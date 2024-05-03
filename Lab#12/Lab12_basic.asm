ORG		0000H
LJMP	INIT
ORG		0023H // 傳輸中斷
LJMP	SERI
ORG		0050H

INIT:	
	SETB	ES // 開啟傳輸中斷
	CLR	TI // 清除傳輸完成旗標
	CLR	RI // 清除接收中斷旗標

	SETB	EA // 開啟全域中斷
	SETB	PS // 優先度設定為高
	MOV	TMOD,#00100000B // 設定 TIMER1 為 AUTORELOAD 模式

	// 設定鮑率為 2400
	MOV	TL1,#0F3H	
	MOV	TH1,#0F3H

	ANL	PCON,#07FH // 設定 SMOD=1
	SETB	TR1 // 啟動 Timer1 開始計時	
	CLR	SM2	 // SERIAL PORT MODE 1 (傳輸模式為 MD1)

	SETB	SM1 // 設定 SERIAL PORT MODE 1
	CLR	SM0
	SETB	REN // 啟用自動接收

// 死循環
LOOP:	
	JMP	$		

SERI:	
	JB		RI,RECV	// 若接收中斷觸發
    JB		TI,SEND	// 若傳輸中斷觸發
	RETI

RECV:
	CLR		RI	// 清除接收中斷旗標			
	MOV		A,SBUF	// 讀取接收的資料
	ADD		A,#020H	// 轉換為小寫字元
	MOV		SBUF,A	// 送出資料
	RETI // 回傳中斷

SEND:
	CLR		TI	// 清除傳輸中斷旗標
	RETI // 回傳中斷
    
	END
