/*
alarm clock 闹钟相关
    S=4:闹钟设置模式，分钟设置
    S=5:闹钟设置模式，小时设置
Alarm.v by ZelongXiao
2026.06.06
*/

module Alarm(clk100, rst, state, add, sub, ma, ha);
input clk100, rst, add, sub;
input [2:0] state;
output reg [5:0] ma, ha;

    wire addIn=~add;
    wire subIn=~sub;
    reg addLa, subLa;
    wire addPulse=addIn&~addLa;
    wire subPulse=subIn&~subLa;

    always @(posedge clk100 or negedge rst) begin
        if(!rst) begin
            addLa<=0;
            subLa<=0;
        end
        else begin
            addLa<=addIn;
            subLa<=subIn;
        end
    end

    always @(posedge clk100 or negedge rst) begin
        if(!rst) begin
            ma<=0;
            ha<=0;
        end
        else begin
            if(state==4) begin
                if(addPulse) ma<=(ma==59)? 0 : ma+1;
                else if(subPulse) ma<=(ma==0)? 59 : ma-1;
            end
            else if(state==5) begin
                if(addPulse) ha<=(ha==23)? 0 : ha+1;
                else if(subPulse) ha<=(ha==0)? 23 : ha-1;
            end
        end
    end

endmodule