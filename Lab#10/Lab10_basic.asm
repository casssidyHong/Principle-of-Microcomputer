ORG     0000H       // 程式起始位置
LJMP    INIT        // 跳轉至初始化子程序
ORG     000BH       // 定位至 Timer 0 中斷服務程序
LJMP    ITR_ET0        // 跳轉至 Timer 0 中斷服務程序 (MODE 2)
ORG     0013H       // 定位至外部中斷1 中斷服務程序
LJMP    ITR_EX1        // 跳轉至外部中斷 1 中斷服務程序
ORG     001BH       // 定位至計數器 1 中斷服務程序
LJMP    ITR_ET1        // 跳轉至計數器 1 中斷服務程序 (MODE 2)
ORG     0050H       // 其他程式碼存放位置

INIT:   
    //全局中斷
    SETB    EA          // 啟用

    //Timer0中斷設置
    SETB    ET0         // 啟用
    MOV     TH0, #227   // 高位計數器初始值=58ms
    MOV     TL0, #227   // 低位計數器初始值=58ms

    //外部中斷1(回音信號中斷處理)
    SETB    EX1         // 啟用
    SETB    IT1         // 下降沿觸發

    //計數器1中斷
    ETB     ET1         // 啟用
    SETB    TR1         // 啟動

    MOV     TMOD, #11100010B // 配置計時器/計數器模式

    MOV     DPTR, #NUM   // 設定數碼管顯示表的資料指針
    LCALL   RESET        // 調用重置子程序
    MOV     P2, #0FFH    // 初始化 P2(高電位)
    SETB    TR0         // 啟動 Timer 0

/*顯示循環，逐一更新四個數碼管顯示
  (R4->D1, R3->D2, R2->D3, R1->D4)
  Step1: 先將P2設定為高電位
  Step2: 將要調用的暫存器數值輸出到P0
  Step3: 顯示在要顯示的位置(D1-D4)
  Step4: 延遲*/
DISPLAY:    
    //R4->D1
    MOV     P2, #0FFH    // P2 高電位
    MOV     P0, R4       
    MOV     P2, #11110111B 
    LCALL   DELAY       

    //R3->D2
    MOV     P2, #0FFH    // P2 高電位
    MOV     P0, R3       
    MOV     P2, #11111011B 
    LCALL   DELAY       

    //R2->D3
    MOV     P2, #0FFH    // P2 高電位
    MOV     P0, R2       
    MOV     P2, #11111101B 
    LCALL   DELAY       

    //R1->D4
    MOV     P2, #0FFH    // P2 高電位
    MOV     P0, R1       
    MOV     P2, #11111110B 
    LCALL   DELAY       

    LJMP    DISPLAY         // 跳回至 DISPLAY 子程序

ITR_ET0:   
    CPL     P1.0        // 反轉 P1.0 的狀態
    RETI                // 返回中斷

ITR_EX1:   
    LCALL   CALCULATE   // 調用計算子程序
    LCALL   RESET       // 調用重置子程序
    RETI                // 返回中斷

ITR_ET1:   
    INC     R5           // R5+1
    MOV     TL1, #156    // 設定計數器1的閥值 (100 次)
    RETI                 // 返回中斷

/*利用DIV更新A,B的數值後再輸入暫存器
  DIV AB -> A/B = (new)A ...(new)B*/
CALCULATE:    
    MOV     A, TL1       
    CLR     C           // 清除進位標誌

    //A=A-156, B=10計算(A/B)的商和餘數
    SUBB    A, #156      
    MOV     B, #10       
    DIV     AB           
    
    /*把計算出來的數值對應到Table的相對位置取出
      商 -> 放入R3, 餘數 -> 放入R4*/
    MOVC    A, @A+DPTR   
    MOV     R3, A        
    MOV     A, B         
    MOVC    A, @A+DPTR   
    MOV     R4, A        

    //A=R5, B=10重新計算(A/B)的商和餘數
    MOV     A, R5        
    MOV     B, #10       
    DIV     AB          
    
    /*把計算出來的數值對應到Table的相對位置取出
      商 -> 放入R1, 餘數 -> 放入R2*/
    MOVC    A, @A+DPTR   
    MOV     R1, A        
    MOV     A, B         
    MOVC    A, @A+DPTR   
    MOV     R2, A        
    RET                  // 返回

//重新設置
RESET:   
    MOV     TL1, #156    // 重置計數器1的閥值 (100 次)
    MOV     R5, #0       // R5歸0
    RET                 // 返回

//延遲
DELAY:  
    MOV     R0, #10        
DELAY2:     
    MOV     R7, #100       
DELAY1: 
    DJNZ    R7, DELAY1     
    DJNZ    R0, DELAY2     
    RET                   

NUM:    
    DB  0C0H,0F9H,0A4H,0B0H,099H,092H,082H,0F8H,080H,090H //0-9
    END                 

; 顯示
; R1=1000   D1  P2.0  除以 R5 10   將 A
; R2= 100   D2  P2.1              將 B
; R3=  10   D3  P2.2  除以 R6 10   將 A
; R4=   1   D4  P2.3              將 B
; R5=       (COUNT/100) % 100
; R6=       (COUNT)     % 100 = TL1
; P2= 顯示迴圈

; Timer 0 -> CPL P1.0 -硬體接線-> P3.5 作為計數器 1 的輸入 <- 閘 = P3.3 <- 回音 = 計數器開關
; 當回音為高電位時，計數次數 = 距離（公分）
