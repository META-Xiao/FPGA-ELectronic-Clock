/*
ModeSel 选择模式输出 MinAdd、HourAdd 和 [1:0] state
        分别是分钟加1、小时加1和计时使能信号
        S=0:正常时钟模式
        S=1:设置模式，分钟设置
        S=2:设置模式，小时设置
        S=3:跑表/计时模式
        S=4:闹钟设置模式，分钟设置
        S=5:闹钟设置模式，小时设置
        0->1->2->3->4->5->0 循环切换，按下mode 6次为周期
            在S={1,2,3,4,5}下 长按mode回到S=0
            在S={1,2,4,5}下 10s内不操作回到S=0
ModeSel.v by ZelongXiao
2026.06.06
*/

module ModeSel(clk100, rst, mode, add, Sub, MinAdd, HourAdd, MinSub, HourSub, state);
input clk100, rst, mode, add, Sub;
output reg MinAdd, HourAdd, MinSub, HourSub;
output reg [2:0] state;

    reg modeLa, addLa, SubLa;
    reg [15:0] modeHoldCnt;
    reg [15:0] idleCnt;
    
    wire modeIn=~mode;
    wire addIn=~add;
    wire SubIn=~Sub;

    wire modePulse = modeIn & ~modeLa;
    wire addPulse  = addIn  & ~addLa;
    wire SubPulse = SubIn & ~SubLa;
    wire modeLong  = (modeHoldCnt >= 200);

    // 边沿检测
    always @(posedge clk100 or negedge rst) begin
        if (!rst) begin
            modeLa<=0;
            addLa<=0;
        end
        else begin
            modeLa<=modeIn;
            addLa <=addIn;
            SubLa <=SubIn;
        end
    end

    // 长按检测
    always @(posedge clk100 or negedge rst) begin
        if (!rst)
            modeHoldCnt<=0;
        else if (!modeIn || state==0)
            modeHoldCnt<=0;
        else if (modeHoldCnt<16'd65535)
            modeHoldCnt<=modeHoldCnt+1;
    end

    // 状态机
    always @(posedge clk100 or negedge rst) begin
        if (!rst) begin
            state<=0;
            idleCnt<=0;
        end
        else begin
            if (modePulse || addPulse || SubPulse)
                idleCnt<=0;
            else if (state==1 || state==2 || state==4 || state==5) begin
                if(idleCnt<2000) idleCnt<=idleCnt+1;
            end
            else idleCnt<=0;

            if(modeLong) begin
                state<=0;
            end
            else if(modePulse) begin
                state<=(state==5)? 0: state+1;
            end
            else if ((state==1 || state==2 || state==4 || state==5) && idleCnt >= 2000) begin
                state<=0;
            end
        end
    end

    // 输出
    always @(posedge clk100 or negedge rst) begin
        if (!rst) begin
            MinAdd<=0;
            HourAdd<=0;
            MinSub<=0;
            HourSub<=0;
        end
        else begin
            MinAdd<=0;
            HourAdd<=0;
            MinSub<=0;
            HourSub<=0;

            if (addPulse) begin
                case (state)
                    1: MinAdd<=1;
                    2: HourAdd<=1;
                    default: ;
                endcase
            end
            else if (SubPulse) begin
                case (state)
                    1: MinSub<=1;
                    2: HourSub<=1;
                    default: ;
                endcase
            end
        end
    end

endmodule