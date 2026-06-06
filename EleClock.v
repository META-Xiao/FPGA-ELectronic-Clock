/*
top moudle 顶层设计
EleClock by ZelongXiao
2026.06.06
*/

module DivNum(in, out1, out2);
input [5:0] in;
output [3:0] out1, out2;
    assign out1=in/10;
    assign out2=in%10;
endmodule 

module EleClock(clk, rst, mode, add, sel, seg);
input clk, rst, mode, add;
output [5:0] sel;
output [7:0] seg;
wire clk1k, clk100, clk1;
wire [5:0] s, m, h;
wire [3:0] s1, s2, m1, m2, h1, h2;
reg [5:0] ss, mm, hh;
wire [3:0] ss1, ss2, mm1, mm2, hh1, hh2;
wire [5:0] sel1, sel2;
wire [7:0] seg1, seg2;
wire MinAdd, HourAdd, CountEn;

div Div(clk, rst, clk1k, clk100, clk1);

ModeSel ModeSel1(clk1, rst, mode, add, MinAdd, HourAdd, CountEn);

Settings Settings1(clk1, rst, MinAdd, HourAdd, s, m, h);

// always @(posedge clk1 or negedge rst) begin
//     if (!rst) begin 
//         s<=6'b0;
//         m<=6'b0;
//         h<=6'b0;
//     end
//     else begin
//         if(s==6'd59) begin
//             s<=6'b0;
//             if(m==6'd59) begin
//                 m<=6'b0;
//                 if(h==6'd23) h<=6'b0;
//                 else h<=h+1;
//             end
//             else m<=m+1;
//         end
//         else s<=s+1;
//     end
// end

DivNum DivNum1(s, s1, s2);
DivNum DivNum2(m, m1, m2);
DivNum DivNum3(h, h1, h2);
DivNum DivNum4(ss, ss1, ss2);
DivNum DivNum5(mm, mm1, mm2);
DivNum DivNum6(hh, hh1, hh2);

display Display1(rst, clk1k, s2, s1, m2, m1, h2, h1, sel1, seg1);
display Display2(rst, clk1k, ss2, ss1, mm2, mm1, hh2, hh1, sel2, seg2);
assign sel = (CountEn==0)? sel1 : sel2;
assign seg = (CountEn==0)? seg1 : seg2;



endmodule