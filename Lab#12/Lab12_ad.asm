ORG 0000H         
AJMP INIT       
ORG 000BH        //IMER0 中斷
AJMP Clock   
ORG 0023H        //串口接收中斷
AJMP REC        
ORG 0050H        

INIT:
    SETB EA  //全域中斷
    SETB ES  //串口中斷
    SETB PT0  //優先度設定
    SETB ET0  //開啟TIMER0中斷

    MOV R0,#255 
    MOV R1,#31  
    MOV TL0, #0E6H  //TIMER0 低位初始值
    MOV TH0, #0E6H   //TIMER0 高位初始值

    /*TIMER1 -> AUTORELOAD
      TIMER0 -> Mode 0*/
    MOV TMOD,#00100000B  

    //鮑率 2400
    MOV TL1, #0E6H
    MOV TH1, #0E6H
    ORL PCON, #80H  //SMOD=1

    //Timer設定
    SETB TR1 //啟動 Timer1 開始計時
    CLR TR0 //Timer0 不計時
    CLR TF0 //清除 Timer0 中斷旗標

    //Port設定
    CLR SM2 //串口傳輸模式 Mode 1
    
    CLR SM0
    SETB SM1  //SERIAL PORT MODE1
    SETB REN  //啟動自動接收
    CLR RI   //清除接收中斷旗標

    MOV DPTR,#TONE //設定音符表的指針

REC:
    //清除輸出, 接收中斷旗標
    MOV P1,#0  
    CLR RI     

    MOV A,SBUF  //讀取串口接收的數據
    SUBB A,#49  //ASCII -> NUM

    //Table存的時候是7個一組 有3組 (HIGH, LOW, 音色)
    // HIGH
    MOV R3,A    //備份數字(一開始串口接收的數據
    MOVC A,@A+DPTR 
    MOV R1,A    //複製到R1

    //LOW
    MOV A,R3    //恢復備份(一開始串口接收的數據
    ADD A,#7    //+7換成下一組 (LOW)
    MOVC A,@A+DPTR 
    MOV R0,A    //複製到R0

    //設定TH0和TL0的值
    MOV TL0,R0 
    MOV TH0,R1

    //音色
    //計算播放的次數
    MOV A,R0    //恢復備份
    ADD A,#7   //+7換成下一組 (音色)
    MOVC A,@A+DPTR //從音符表中取執行次數的值
    MOV R4,A    //複製到R4

    SETB TR0    //啟動TIMER0開始運行
    ACALL SOUND  //播放音符
    CLR TR0     //停止TIMER0

//無限循環
LOOP: 
    SJMP $     

//MODE0計時中斷處理程序
Clock:         
    MOV TL0,R0  //設定TIMER0的低位值
    MOV TH0,R1  //設定TIMER0的高位值
    CPL P1.0    //反向輸出方波信號
    
    RETI        //返回中斷

SOUND:          
    MOV R7,#3   
SOUND1:
    JNB TF0,$   //等待Timer0中斷
    DJNZ R7,SOUND1 
    DJNZ R4,SOUND  
    RETI         //返回中斷

TONE:
    //TH0
    DB 226,229,232,233,236,238,240
    //TL0
    DB 4,12,9,20,2,8,6
    //HZ/4 -> 音色
    DB 131,147,165,175,196,220,247

END       
