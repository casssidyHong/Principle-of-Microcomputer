//初始設定
ORG 0000H; 
AJMP MAIN;
ORG 0050H;

MAIN :
    MOV A, #7FH; //將A初始化為01111111 -> 最左邊的燈亮

LOOP:
    MOV P0, A ; //把A的值輸入P0, 也就把01111111的信號輸入LED燈裡面
    RR A; //讓A所有的bit都向右移一位, 原本在最右的bit則移至最左
    ACALL DELAY; //跳出迴圈, 跑到 "DELAY" 這個function
    JMP LOOP; //跳到 "LOOP", 也就是在重新執行這個迴圈
    
DELAY:
    MOV R5, #0FFH; //令R5的初始值為255

DELAY1:
    MOV R6, #0FFH; //令R6的初始值為255
    
DELAY2:
    MOV R7, #05H; //令R7的初始值為5

DELAY3:
    DJNZ R7, DELAY3 ; //每一次都將R7的數值-1, 如果減完之後R7≠0, 就跳到 "DELAY3" 繼續執行
                       如果減完之後R7=0, 就直接執行下一行
    DJNZ R6, DELAY2 ; //每一次都將R6的數值-1, 如果減完之後R6≠0, 就跳到 "DELAY2" 繼續執行
                       如果減完之後R6=0, 就直接執行下一行
    DJNZ R5, DELAY1 ; //每一次都將R5的數值-1, 如果減完之後R5≠0, 就跳到 "DELAY1" 繼續執行
                       如果減完之後R5=0, 就直接執行下一行
    RET; //回到ACALL的下一行, 也就是JMP LOOP
END;

