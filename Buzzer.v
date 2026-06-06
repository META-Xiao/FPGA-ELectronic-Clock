/*
buzzer 整点蜂鸣器发声
    reportOn: 整点发声标志
    alarmOn: 闹钟发声标志
Buzzer.v by ZelongXiao
2026.06.06
*/

module Buzzer(clk1k, clk100, rst, s, m, h, ma, ha, buzzer);
input clk1k, clk100, rst;
input [5:0] s, m, h, ma, ha;
output buzzer;

    reg [7:0] cnt1k;
    reg [5:0] cnt100;
    reg reportOn, alarmOn;
    reg [5:0] mLa, sLa;
    reg [5:0] mLa100, maLa100, hLa100, haLa100;

    always @(posedge clk1k or negedge rst) begin
        if(!rst) begin
            cnt1k<=0;
            reportOn<=0;
            mLa<=1;
            sLa<=1;
        end
        else begin
            mLa<=m;
            sLa<=s;
            if(m==0 && s==0 && !(mLa==0 && sLa==0)) reportOn<=1;
            if(reportOn) begin
                if(cnt1k>=249) begin
                    cnt1k<=0;
                    reportOn<=0;
                end
                else cnt1k<=cnt1k+1;
            end
        end
    end

    always @(posedge clk100 or negedge rst) begin
        if(!rst) begin
            cnt100<=0;
            alarmOn<=0;
            mLa100<=1;
            maLa100<=1;
            hLa100<=1;
            haLa100<=1;
        end
        else begin
            mLa100<=m;
            maLa100<=ma;
            hLa100<=h;
            haLa100<=ha;
            if(h==ha && m==ma && !(hLa100==ha && mLa100==ma)) alarmOn<=1;

            if(alarmOn) begin
                if(cnt100>=49) begin
                    cnt100<=0;
                    alarmOn<=0;
                end
                else cnt100<=cnt100+1;
            end
        end
    end

    assign buzzer = reportOn  ? clk1k:
                    alarmOn ? clk100: 1'b1;

endmodule