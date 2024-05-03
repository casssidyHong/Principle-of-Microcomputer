//初始設置
ORG 0000H; 
AJMP MAIN;
ORG 0050H;

MAIN :
    MOV 	R1,	#09H; //因為學號只有9位, 所以將R1初始化為9
	MOV 	DPTR, #ME; //將ME的位置存入DPTR

LOOP:
    DJNZ 	R1,	RESET; //每次將R1減一, 若R1≠0, 則跳到"RESET"執行
						 若R1=0, 則跳到下一行執行 (13)
	MOV		R1, #09H; //把R1的數值改為9

RESET:
	MOV		A, 	R1; //把R1的值輸入A
	MOVC	A, 	@A+DPTR; //將Table(DPTR)的第A筆數值輸給A
	MOV		P0, A; //把A的信號輸入LED燈裡面
	MOV		A,	P1; //把指撥開關的數值輸入A
	ACALL	DELAY; //跳出迴圈, 執行"DELAY"副程式
	JMP		LOOP; //跳回"LOOP", 也就是重新執行這個迴圈

/*"DELAY": 同Lab1, 為避免LED的數值跳動太快,
  導致我們肉眼無法判讀, 因此需要延遲LED每次的顯示時長*/
DELAY:
    MOV R5, A; //把A的數值輸入R5,
				 此時A代表指撥開關的數值, A越大迴圈跑越多次, LED跳動越慢
				 
DELAY1:
    MOV R6, #0FFH; //令R6初始值為255
DELAY2:
    MOV R7, #09H; //令R7初始值為9
DELAY3:
    DJNZ R7, DELAY3; 
    DJNZ R6, DELAY2; 
    DJNZ R5, DELAY1; 
    RET; 

/*"ME": 印出的學號table, 因為R1是從9開始往下扣
  所以學號的第一位要在最下面, 並依次序往上寫*/
ME:
	DB	00; //因為是用DJNZ, 所以第0條不會被讀到
	DB	10110000B; //3
	DB	10011001B; //4
	DB	11111001B; //1
	DB	11000000B; //0
	DB	10010010B; //5
	DB	10010010B; //5
	DB	11000000B; //0
	DB	11111001B; //1
	DB	11111001B; //1

END;

