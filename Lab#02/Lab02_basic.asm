// 初始設定
ORG 0000H; 
AJMP MAIN;
ORG 0050H;

MAIN :
    MOV A, P1; //把P1讀取到的訊號輸入至A暫存
    MOV P0, A; //把A的值輸入P0, 也就是把燈亮信號輸入到LED中
    ACALL DELAY; //跳出迴圈, 跑到 "DELAY"這個副程式
    JMP MAIN; //跳回 "MAIN" 也就是現在這個程式

// 和Lab1一樣
DELAY:
    MOV R5, #0FFH; //令R5的初始值為255
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
    RET; //回到ACALL的下一行, 也就是JMP MAIN
END;



