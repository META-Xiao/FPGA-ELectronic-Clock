/*
top moudle 顶层设计
EleClock by ZelongXiao
2026.06.06
*/

module DivNum(in, out1, out2);
input [5:0] in;
output [3:0] out1, out2;
    assign out1 = in / 10;
    assign out2 = in % 10;
endmodule 

module EleClock(clk, rst, sel, seg);
input clk, rst;
output [5:0] sel;
output [6:0] seg;
wire clk1k, clk100, clk1;
reg [5:0] s, m, h;
wire [3:0] sec1, sec2, min1, min2, hour1, hour2;

div Div(clk, rst, clk1k, clk100, clk1);

always @(posedge clk1 or negedge rst) begin
    if (!rst) begin 
        s<=6'b0;
        m<=6'b0;
        h<=6'b0;
    end
    else begin
        if(s==6'd59) begin
            s<=6'b0;
            if(m==6'd59) begin
                m<=6'b0;
                if(h==6'd23) h<=6'b0;
                else h<=h+1;
            end
            else m<=m+1;
        end
        else s<=s+1;
    end
end

DivNum DivNum1(s, sec1, sec2);
DivNum DivNum2(m, min1, min2);
DivNum DivNum3(h, hour1, hour2);

display Display(rst, clk1k, sec2, sec1, min2, min1, hour2, hour1, sel, seg);


endmodule