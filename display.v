/*
Display module 输入6个4位二进制数（0到9），输出数码管显示
display.v by ZelongXiao
2026.06.06
*/

module ToSeg(D, seg);
    input [3:0] D;
    output reg [6:0] seg;

    always @(*) begin
        case(D)
            // 映射 {G, F, E, D, C, B, A} = {6, 5, 4, 3, 2, 1, 0}
            4'd0:  seg=7'b1000000;
            4'd1:  seg=7'b1111001;
            4'd2:  seg=7'b0100100;
            4'd3:  seg=7'b0110000;
            4'd4:  seg=7'b0011001;
            4'd5:  seg=7'b0010010;
            4'd6:  seg=7'b0000010;
            4'd7:  seg=7'b1111000; 
            4'd8:  seg=7'b0000000;
            4'd9:  seg=7'b0010000;
            4'd10: seg=7'b0001000;
            4'd11: seg=7'b0000011;
            4'd12: seg=7'b1000110;
            4'd13: seg=7'b0100001;
            4'd14: seg=7'b0000110;
            4'd15: seg=7'b0001110; 
        endcase
    end
endmodule

module display(rst, clk1k, D0, D1, D2, D3, D4, D5, sel, seg);
    input rst, clk1k;
    input [3:0] D0, D1, D2, D3, D4, D5;
    output [5:0] sel;
    output [6:0] seg;
    reg [5:0] active;
    reg [3:0] Dsel;
    wire [6:0] SegWire;

    always @(posedge clk1k or negedge rst) begin
        if (!rst)
            active <= 6'b100000;
        else
            active <= {active[0], active[5:1]};
    end

    always @(*) begin
        case (active)
            6'b100000: Dsel = D0;
            6'b010000: Dsel = D1;
            6'b001000: Dsel = D2;
            6'b000100: Dsel = D3;
            6'b000010: Dsel = D4;
            6'b000001: Dsel = D5;
            default: Dsel = 4'b0;
        endcase
    end

    assign sel = ~active;

    ToSeg u_ToSeg(.D(Dsel), .seg(SegWire));
    assign seg = SegWire;

endmodule