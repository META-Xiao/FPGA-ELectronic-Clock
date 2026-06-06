/*
ModeSel 选择模式输出 MinAdd、HourAdd 和 [1:0] state
        分别是分钟加1、小时加1和计时使能信号
        S=0:正常时钟模式
        S=1:设置模式，分钟设置
        S=2:设置模式，小时设置
        S=3:跑表/计时模式
        0->1->2->3->0 循环切换，按下mode 4次为周期
            在S={1,2,3}下 长按mode回到S=0
            在S={1,2}下 10s内不操作回到S=0
ModeSel.v by ZelongXiao
2026.06.06
*/

module ModeSel(clk, rst, mode, add, MinAdd, HourAdd, state);
input clk, rst, mode, add;
output reg MinAdd, HourAdd;
output reg [1:0] state;

    reg modeLa, addLa;
    reg [15:0] modeHoldCnt;
    reg [15:0] idleCnt;
    
    wire mode_i = ~mode;
    wire add_i  = ~add;

    wire modePulse = mode_i & ~modeLa;
    wire addPulse  = add_i  & ~addLa;
    wire modeLong  = (modeHoldCnt >= 16'd200);

    // 边沿检测
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            modeLa<=0;
            addLa<=0;
        end
        else begin
            modeLa<=mode_i;
            addLa <=add_i;
        end
    end

    // 长按检测
    always @(posedge clk or negedge rst) begin
        if (!rst)
            modeHoldCnt<=16'd0;
        else if (!mode_i || state==2'd0)
            modeHoldCnt <= 16'd0;
        else if (modeHoldCnt < 16'd65535)
            modeHoldCnt <= modeHoldCnt + 16'd1;
    end

    // 状态机
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state  <=2'd0;
            idleCnt <= 16'd0;
        end
        else begin
            if (modePulse || addPulse)
                idleCnt <= 16'd0;
            else if (state == 2'd1 || state == 2'd2) begin
                if (idleCnt < 16'd2000)
                    idleCnt <= idleCnt + 16'd1;
            end
            else
                idleCnt <= 16'd0;

            if (modeLong) begin
                state <= 2'd0;
            end
            else if (modePulse) begin
                state<=(state==2'd3)? 2'd0: state+1;
            end
            else if ((state == 2'd1 || state == 2'd2) && idleCnt >= 16'd2000) begin
                state <= 2'd0;
            end
        end
    end

    // 输出
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            MinAdd  <= 1'b0;
            HourAdd <= 1'b0;
        end
        else begin
            MinAdd  <= 1'b0;
            HourAdd <= 1'b0;

            if (addPulse) begin
                case (state)
                    2'd1: MinAdd  <= 1;
                    2'd2: HourAdd <= 1;
                    default: ;
                endcase
            end
        end
    end

endmodule