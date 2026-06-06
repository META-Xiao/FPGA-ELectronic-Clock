/*
Div 分频器
div.v by ZelongXiao
2026.06.06
*/

module div(clk, rst, clk1k, clk100, clk1);
    input clk, rst;
    output reg clk1k, clk100, clk1;
    reg [14:0] cnt1k;
    reg [2:0]  cnt100;
    reg [5:0]  cnt1;

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            cnt1k<=15'b0;
            clk1k<=1'b0;
        end
        else if(cnt1k>=15'd24_999) begin
            cnt1k<=15'b0;
            clk1k<=~clk1k;
        end
        else begin
            cnt1k<=cnt1k+1'b1;
        end
    end

    always @(posedge clk1k or negedge rst) begin
        if(!rst) begin
            cnt100<=3'b0;
            clk100<=1'b0;
        end
        else if(cnt100>=3'd4) begin
            cnt100<=3'b0;
            clk100<=~clk100;
        end
        else begin
            cnt100<=cnt100+1'b1;
        end
    end

    always @(posedge clk100 or negedge rst) begin
        if(!rst) begin
            cnt1<=6'b0;
            clk1<=1'b0;
        end
        else if(cnt1>=6'd49) begin
            cnt1<=6'b0;
            clk1<=~clk1;
        end
        else begin
            cnt1<=cnt1 + 1'b1;
        end
    end

endmodule