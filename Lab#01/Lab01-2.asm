ORG 0000H;
AJMP MAIN;
ORG 0050H;

MAIN :
    MOV A, #00H; //宣告A 為00000000
    MOV R3, #00H; //宣告R3 為00000000
    MOV R0, #0FEH; //將R0初始化為01111111 -> 最左邊的燈亮
    MOV R1, #07FH; //將R1初始化為10000000 -> 最右邊的燈亮

LOOP:
    //因為只有A可以進行RR或RL, 因此會先把數值輸入A進行轉換之後再存回去R裏面
    MOV A, R0; //把R0的值輸入A 
    RR A; //讓A所有的bit都向右移一位, 原本在最右的bit則移至最左
    MOV R0, A ; //把右移過的A輸回去R0

    MOV A, R1; //把R1的值輸入A
    RL A; //讓A所有的bit都向左移一位, 原本在最左的bit則移至最右
    MOV R1, A ; //把右移過的A輸回去R0

    ANL A, R0; //把R1和R0 and 起來, 得到現在應該要亮的燈的位子, 因為現在R1與A兩者的數值一樣
                 之後又會需要用到R1, 但A可以視為一個temp, 因此直接用A和R0去and,
                 並把最後的結果數值輸入A -> 現在A就會代表應該要亮的LED燈位置

    MOV P0, A; //把A的值輸入P0, 也就把A當前的信號輸入LED燈裡面 
    ACALL DELAY; //跳出迴圈, 跑到 "DELAY" 這個function 
    JMP LOOP; //跳到 "LOOP", 也就是在重新執行這個迴圈

//和A部分一樣
DELAY:
    MOV R5, #0FFH; //令R5的初始值為255
DELAY1:
    MOV R6, #0FFH ; //令R6的初始值為255
DELAY2:
    MOV R7, #05H; //令R7的初始值為5
DELAY3:
    DJNZ R7, DELAY3; //每一次都將R7的數值-1, 如果減完之後R7≠0, 就跳到 "DELAY3" 繼續執行
                       如果減完之後R7=0, 就直接執行下一行
    DJNZ R6, DELAY2; //每一次都將R6的數值-1, 如果減完之後R6≠0, 就跳到 "DELAY2" 繼續執行
                       如果減完之後R6=0, 就直接執行下一行
    DJNZ R5, DELAY1; //每一次都將R5的數值-1, 如果減完之後R5≠0, 就跳到 "DELAY1" 繼續執行
                       如果減完之後R5=0, 就直接執行下一行
    RET ; //回到ACALL的下一行, 也就是JMP LOOP
END;

