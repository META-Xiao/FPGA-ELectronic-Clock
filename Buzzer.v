/*
buzzer 整点蜂鸣器发声
Buzzer.v by ZelongXiao
2026.06.06
*/

module Buzzer(clk1k, rst, s, m, buzzer);
input clk1k, rst;
input [5:0] s, m;
output buzzer;

    reg [7:0] cnt;
    reg f;
    reg [5:0] mLa, sLa;

    always @(posedge clk1k or negedge rst) begin
        if(!rst) begin
            cnt<=0;
            f<=0;
            mLa<=1;
            sLa<=1;
        end
        else begin
            mLa<=m;
            sLa<=s;
            if(m==0 && s==0 && !(mLa==0 && sLa==0)) f<=1;
            if(f) begin
                if(cnt>=124) begin
                    cnt<=0;
                    f<=0;
                end
                else cnt<=cnt+1;
            end
        end
    end

    assign buzzer=f? clk1k : 1'b1;

endmodule