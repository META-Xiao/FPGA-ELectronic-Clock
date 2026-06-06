/*
Display module 输入6个4位二进制数（0到9），输出数码管显示
        使用1kHz刷新，DP闪烁时间间隔250ms
display.v by ZelongXiao
2026.06.06
*/

module ToSeg(D, seg);
input [3:0] D;
output reg [7:0] seg;

    always @(*) begin
        case(D)
            // 映射 {DP, G, F, E, D, C, B, A} = {7, 6, 5, 4, 3, 2, 1, 0}
            0:  seg=8'b11000000;
            1:  seg=8'b11111001;
            2:  seg=8'b10100100;
            3:  seg=8'b10110000;
            4:  seg=8'b10011001;
            5:  seg=8'b10010010;
            6:  seg=8'b10000010;
            7:  seg=8'b11111000; 
            8:  seg=8'b10000000;
            9:  seg=8'b10010000;
            10: seg=8'b10001000;
            11: seg=8'b10000011;
            12: seg=8'b11000110;
            13: seg=8'b10100001;
            14: seg=8'b10000110;
            15: seg=8'b10001110; 
        endcase
    end
endmodule

module display(rst, clk1k, state, D0, D1, D2, D3, D4, D5, sel, seg);
    input rst, clk1k;
    input [3:0] D0, D1, D2, D3, D4, D5;
    input [1:0] state;
    output [5:0] sel;
    output [7:0] seg;
    reg [5:0] active;
    reg [3:0] Dsel;
    wire [7:0] SegWire;
    
    reg [8:0] cnt500;
    reg dp;

    always @(posedge clk1k or negedge rst) begin
        if (!rst) begin
            active<=6'b100000;
            cnt500<=0;
            dp<=1;
        end
        else begin
            active<={active[0], active[5:1]};
            if (cnt500>=249) begin
                cnt500<=0;
                dp<=~dp;
            end
            else
                cnt500<=cnt500+1;
        end
    end

    always @(*) begin
        case (active)
            6'b100000: Dsel=D0;
            6'b010000: Dsel=D1;
            6'b001000: Dsel=D2;
            6'b000100: Dsel=D3;
            6'b000010: Dsel=D4;
            6'b000001: Dsel=D5;
            default: Dsel=0;
        endcase
    end

    assign sel = ~active;

    ToSeg TS(.D(Dsel), .seg(SegWire));

    // S=1, S=2时，分钟、时钟闪烁
    wire blink = (state==1 && (active==6'b001000 || active==6'b000100)) ||
                 (state==2 && (active==6'b000010 || active==6'b000001));
    assign seg = blink? 
                 (dp ? 8'b11111111 : SegWire):
                 ((active==6'b001000 || active==6'b000010)? {dp, SegWire[6:0]}:SegWire);

endmodule