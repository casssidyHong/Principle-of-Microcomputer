ORG  0000H
LJMP  INIT
ORG  0023H  ;傳輸中斷
LJMP  SERI
ORG  0050H

//設定Serial Port Interrupt中斷
INIT:     
    SETB   EA   ;開啟中斷(enable all interrupt)
    SETB   ES   ;開啟傳輸中斷(serial port interrupt)
    CLR   TI   ;清除旗標(clear transfer flag)
    CLR   RI   ;清除旗標(clear read flag)
    SETB   PS   ;優先度設定(high priority)
    MOV   TMOD, #00100001B  

    //Timer1,Mode2(Auto Reload);Timer0,Mode1
    MOV   TL1, #0E6H ;鮑率設定baud rate = 2400
    MOV   TH1, #0E6H ;Initial value = 230
    ORL   PCON, #80H ;SMOD=1
    SETB   TR1   ;Timer1開始計時
    
    //Serial Port Mode1
    CLR   SM2  ;傳輸模式為MD1
    CLR   SM0
    SETB   SM1
    SETB   REN  ;enable Receive自動接收
    SETB  P1.0   ;signal source of square wave
    MOV   A, #0

//死迴圈
FREEZE:     
    JZ   $  

// set the loop num = (R1-1)*256+R2 => for 1s
// high-digit
SETHVALUE:    
    MOV   DPTR,#HNUM 
    MOV   A,R0
    MOVC  A,@A+DPTR
    INC   A
    MOV   R1,A

// low-digit
SETLVALUE:
    MOV   DPTR,#LNUM 
    MOV   A,R0
    MOVC  A,@A+DPTR
    MOV   R2,A

LOOP:
    //high-digit T0
    MOV    DPTR,#TBLH
    MOV    A,R0
    MOVC   A,@A+DPTR 

    JZ     FREEZE ;if A==0, jump to freeze
    MOV    TH0,A

    MOV    DPTR,#TBLL;read low-digit initial value for Timer0
    MOV    A,R0
    MOVC   A,@A+DPTR  
    MOV    TL0,A

    SETB   TR0   ;Timer0開始運作
    JNB    TF0,$  ;check overflow

    CLR    TR0   ;停止Timer0
    CLR    TF0   ;clear Timer0 flag
    CPL    P1.0   ;complement the signal(square wave)

    DJNZ   R2,LOOP
    MOV    R2,#255 
    DJNZ   R1,LOOP
    MOV    A,#0
    JMP    FREEZE

SERI:     
    CLR   RI   ;清除旗標(clear read flag)
    MOV   A,SBUF  ;read number(data)
    CLR   C   ;clear carry(因為下一步是減)
    SUBB  A,#31H  ;transform ASCII to decimal
    MOV   R0,A  ;the number is stored at R0
    MOV   A,#1   ;set ACC to 1 to leave freeze function
    RETI

TBLH:      ;TH0
    DB  226,229,232,233,236,238,240,241,242
TBLL:      ;TL0
    DB  4,13,10,20,3,8,6,2,23

 END