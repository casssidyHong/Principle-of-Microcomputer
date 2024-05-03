// 初始設定
ORG 0000H	
AJMP MAIN	
ORG 0050H

MAIN:
	MOV	A, #07FH; //把A初始化為01111111 (讓最左邊的燈亮)
LOOP:
	MOV P0, A; //把A的值輸入P0, 也就是把燈亮信號輸入到LED中
	RR A; //讓A所有的bit都右移一位, 原本在最右邊的bit移到最左邊
	MOV R1,	A; //因為A等一下要當作指撥開關的數值紀錄, 但下一個LOOP的LED燈亮位置要接續這次的, 所以先將A輸入R1暫存
	MOV A, P1; //把P1的值輸入A (此時A紀錄的數值為指撥開關的數值)
	ACALL DELAY; //跳出迴圈, 跑到 "DELAY"這個副程式
	MOV  A, R1; //把R1, 也就是剛剛算完下一次LED要亮燈的位子的數值輸回A
	JMP LOOP; //跳到 "LOOP", 也就是重新執行現在這個程式

// 和Lab1一樣
DELAY:
    MOV R5, A; //把A的值輸入R5, 這樣LED的速度就會隨著A值上升而變慢
DELAY1:
    MOV R6, #0FFH; //令R6的初始值為255
DELAY2:
    MOV R7, #05H; //令R7的初始值為5
DELAY3:
    DJNZ R7, DELAY3; //每次都將R7的數值-1, 如果減完之後R7≠0, 就跳到 "DELAY3" 繼續執行
                       如果減完之後R7=0, 就執行下一行
    DJNZ R6, DELAY2; //每次都將R6的數值-1, 如果減完之後R6≠0, 就跳到 "DELAY3" 繼續執行
                       如果減完之後R6=0, 就執行下一行
    DJNZ R5, DELAY1; //每次都將R5的數值-1, 如果減完之後R5≠0, 就跳到 "DELAY3" 繼續執行
                       如果減完之後R5=0, 就執行下一行
    RET; //回到ACALL的下一行, 也就是JMP LOOP
END;

