//初始設定
ORG 0000H 
AJMP DOWN
ORG 0050H

DOWN:
  MOV R0, #1000000B  //jp05往下
RIGHT:
  MOV R1, #10000B   //jp04往右

LOOP:
  MOV P0, R0 //把R0輸出給jp05
  MOV P1, R1 //把R1輸出給jp04
  ACALL DELAY //延遲

  //目標:讓R1向右移一個(燈往右亮)
  XCH A, R1 //讓R1的數值先跟A交換
  RR A //A 右旋 1 bit
  XCH A, R1 //再把A跟R1的數值換回來

  /*目標:
  1. R1≠10000000B(還沒跑到最右邊) -> 重新執行LOOP(繼續向右跑)
  2. R1=10000000B(跑到最右邊) -> 執行下面的程式(換下一橫列)*/
  CJNE R1, #10000000B, LOOP 

  //目標:讓R0向右移一個(換下一橫列的燈亮)
  XCH A, R0 //讓R0的數值先跟A交換
  RR A //A 右旋 1 bit
  XCH A, R0 //再把A跟R0的數值換回來

  /*目標:
  1. R0≠10000000B(還沒跑到最下面) -> 重新初始化R1(從最左邊的開始亮)
  2. R0=10000000B(跑到最下面) -> 重新初始化R0(從低一列開始亮)*/
  CJNE R0, #10000000B, RIGHT
  AJMP DOWN

//同Lab1的延遲
DELAY:
  MOV  R5, #0FFH
DELAY1:
  MOV  R6, #0FFH
DELAY2:
  MOV  R7, #005H
DELAY3: 
  DJNZ  R7,DELAY3
  DJNZ  R6,DELAY2
  DJNZ  R5,DELAY1
  RET

END