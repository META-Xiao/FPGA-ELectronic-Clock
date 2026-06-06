/*
top moudle 顶层设计
EleClock by ZelongXiao
2026.06.06
*/

module DivNum(in, out1, out2);
input [6:0] in;
output [3:0] out1, out2;
    assign out1=in/10;
    assign out2=in%10;
endmodule 

module EleClock(clk, rst, mode, key1, key2, sel, seg, LED, buzzer);
input clk, rst, mode, key1, key2;
output [5:0] sel;
output [7:0] seg;
output reg [3:0] LED;
output buzzer;
wire clk1k, clk100, clk1;
wire [5:0] s, m, h;
wire [3:0] s1, s2, m1, m2, h1, h2;
wire [6:0] ms;
wire [5:0] ss, mm;
wire [3:0] ms1, ms2, ss1, ss2, mm1, mm2;
wire [5:0] sel1, sel2;
wire [7:0] seg1, seg2;
wire MinAdd, HourAdd, MinSub, HourSub;
wire [1:0] state;

div Div(clk, rst, clk1k, clk100, clk1);

ModeSel ModeSel1(clk100, rst, mode, key1, key2, MinAdd, HourAdd, MinSub, HourSub, state);

MainClock MC(clk100, rst, MinAdd, HourAdd, MinSub, HourSub, state, s, m, h);

Stopwatch Spt(clk100, rst, key1, key2, ms, ss, mm);

Buzzer Bz(clk1k, rst, s, m, buzzer);
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
DivNum DivNum4(ms, ms1, ms2);
DivNum DivNum5(ss, ss1, ss2);
DivNum DivNum6(mm, mm1, mm2);

display Display1(rst, clk1k, s2, s1, m2, m1, h2, h1, sel1, seg1);
display Display2(rst, clk1k, ms2, ms1, ss2, ss1, mm2, mm1, sel2, seg2);
assign sel = (state!=3)? sel1 : sel2;
assign seg = (state!=3)? seg1 : seg2;

always @(*) begin    
    case (state)
        0: LED = 4'b0001;
        1: LED = 4'b0010;
        2: LED = 4'b0100;
        3: LED = 4'b1000;
        default: LED = 4'b0000;
    endcase

end


endmodule