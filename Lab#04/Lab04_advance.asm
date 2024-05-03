#初始設定
ORG 0000H;
AJMP MAIN;
ORG 0050H;

MAIN:
    MOV R0, #00H; //記錄個位數數字變換的暫存器
    //目標：初始化各個位數數值 05
    MOV R1, #00H; //個位數0
    MOV R2, #05H; //十位數5
    MOV DPTR, #NUM; //將NUM的位置存入DPTR
    MOV R7, #055H; //看哪個燈要亮
LOOP:
    ACALL CHOOSE; //跑到CHOOSE這個副程式
    MOVC  A, @A+DPTR; //將Table(DPTR)的第A個數值輸給A
    MOV P1, R7;//把R7的信號輸入D1-D4當中
    MOV P0, A; //把A的信號輸入A-H當中

    //目標:讓R7右移一bit
    XCH A, R7; //交換A跟R7的數值
    RR A; //讓A的數值右移一個bit, 原本在最右邊的移到最左邊
    XCH A, R7; //交換A跟R7的數值

    INC R0; //R0的值+1

    //目標：計算當前要顯示的數字
    CJNE R0,#0FFH, RESET; //如果R0≠0FFH的話跳到RESET副程式
    MOV R0, #00H; //把R0重新設為0
    INC  R1; //R1+1

    //為了檢查是不是61, 所以跳到另一個副程式
    CJNE R1, #0AH, SIX; //如果R1≠0AH的話跳到SIX副程式
    MOV R1, #00H; //把R1重新設為0
    INC  R2; //R2+1 因為是上數所以要進位

    CJNE R2, #06H, RESET; //如果R2≠6的話跳到RESET副程式
	CJNE R1, #01H, RESET; //如果R1≠1的話跳到RESET副程式->為了顯示60
	MOV R2, #00H; //把R2重新設為0
RESET:
    ACALL DELAY;
    JMP LOOP;
SIX:
    CJNE R2, #06H, RESET; //如果R2≠6的話跳到RESET副程式
    CJNE R1, #01H, RESET; //如果R1≠1的話跳到RESET副程式
    MOV R2, #00H; //如果現在的顯示數字是61(R2=6,R1=1)就把R2歸0->顯示01
    JMP LOOP; //跳回去LOOP重新執行

CHOOSE: 
    CJNE R7, #10101010B, NUM2; //燈亮位置是十位數
    MOV A ,R2; //把R2的值輸給A
NUM2:
    CJNE R7, #01010101B, NUM1; //燈亮位置是個位數
    MOV A ,R1; //把R1的值輸給A                
NUM1:
    RET

/*"DELAY": 同Lab1, 為避免LED的數值跳動太快,
  導致我們肉眼無法判讀, 因此需要延遲LED每次的顯示時長*/
DELAY:   
    MOV R5, #07FH; //令R5初始值為07FH
DELAY1:
    MOV R6, #05CH; //令R6初始值為05CH
DELAY2:
    DJNZ R6, DELAY2;
    DJNZ R5, DELAY1;
    RET;

//NUM的Table
NUM:
 DB 1000000B; //0
 DB 11111001B; //1
 DB 10100100B; //2
 DB 10110000B; //3
 DB 10011001B; //4
 DB 10010010B; //5
 DB 10000010B; //6
 DB 11111000B; //7
 DB 10000000B; //8
 DB 10011000B; //9
 DB  00;
    
 END;