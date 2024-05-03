# 初始設定
ORG 0000H; 
AJMP MAIN;
ORG 0050H;

MAIN :
    MOV R0, #00H //記錄個位數數字變換的暫存器
    //目標：初始化各個位數數值 0009
    MOV R1, #09H //個位數 9
    MOV R2, #00H //十位數 0
    MOV R3, #00H //百位數 0
    MOV R4, #00H //千位數 0
    MOV DPTR, #NUM; //將NUM的位置存入DPTR
    MOV R7, #01110111B; //燈亮的位置

LOOP:
    ACALL CHOOSE; //跑到CHOOSE這個副程式
    MOVC A, @A+DPTR; //將Table(DPTR)的第A個數值輸給A
    MOV P1, R7; //把R7的信號輸入D1-D4當中
    MOV P0, A; //把A的信號輸入A-H當中
    
    //目標：讓R7右移一bit
    XCH A, R7; //交換A跟R7的數值
    RR A; //讓A的數值右移一個bit, 原本在最右邊的移到最左邊
    XCH A, R7; //交換A跟R7的數值

    INC R0; //R0的值+1

    //目標：計算當前要顯示的數字
    CJNE R0,#0FFH, RESET0; //如果R0≠0FFH的話跳到RESET0副程式
    MOV R0, #00H; //把R0重新設為0
    DEC R1; //R1-1 
    
    CJNE R1, #0FFH, RESET0; //如果R1≠0FFH的話跳到RESET0副程式
    MOV R1, #09H; //把R1重新設為9
    DEC R2; //R2-1 當R1(個位數)不夠的時候要借位
    
    CJNE R2, #0FFH, RESET0; //如果R2≠0FFH的話跳到RESET0副程式
    MOV R2, #09H; //把R2重新設為9
    DEC R3; //R3-1 當R2(十位數)不夠的時候要借位
    
    CJNE R3, #0FFH, RESET0; //如果R3≠0FFH的話跳到RESET0副程式
    MOV R3, #09H; //把R3重新設為9
    DEC R4; //R2-1 當R1(百位數)不夠的時候要借位
    
    //因為只顯示到千位數,所以不夠的時候不需要考慮借位,只要重設為9就可以了
    CJNE R4, #0FFH, RESET0;
    MOV R4, #09H; //把R4重新設為9

RESET0:
    ACALL DELAY; //跑到DELAY副程式
    JMP LOOP; //跳回去LOOP重新執行

//目標：看現在亮的是哪個燈的位置
CHOOSE: 
    CJNE R7,#11101110B, NUM4; //如果是千位數的話
    MOV A, R4; //複製R4給A
NUM4:
    CJNE R7, #11011101B, NUM3; //如果是百位數的話
    MOV A, R3; //複製R3給A
NUM3:
	CJNE R7, #10111011B, NUM2; //如果是十位數的話
    MOV A, R2; //複製R2給A
NUM2:
    CJNE R7, #01110111B, NUM1; //如果是個位數的話
    MOV A, R1; //複製R1給A
NUM1:
    RET 

/*"DELAY": 同Lab1, 為避免LED的數值跳動太快,
  導致我們肉眼無法判讀, 因此需要延遲LED每次的顯示時長*/
DELAY:
    MOV  R5, #07FH; //令R5初始值為07FH

DELAY1: 
    MOV  R6, #05CH; //令R6初始值為05CH

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