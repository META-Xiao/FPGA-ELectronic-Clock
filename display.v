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
            4'd0:  seg = 7'b0011111;
            4'd1:  seg = 7'b0000110;
            4'd2:  seg = 7'b0101101;
            4'd3:  seg = 7'b0100111;
            4'd4:  seg = 7'b0110011;
            4'd5:  seg = 7'b0110110;
            4'd6:  seg = 7'b0111110;
            4'd7:  seg = 7'b0000111;
            4'd8:  seg = 7'b0111111;
            4'd9:  seg = 7'b0110111;
            4'd10: seg = 7'b0111011;
            4'd11: seg = 7'b0111100;
            4'd12: seg = 7'b0011100;
            4'd13: seg = 7'b0101110;
            4'd14: seg = 7'b0111001;
            4'd15: seg = 7'b0111000;
        endcase
    end
endmodule

module display(rst, clk1k, D0, D1, D2, D3, D4, D5, sel, seg);
    input rst, clk1k;
    input [3:0] D0, D1, D2, D3, D4, D5;
    output reg [5:0] sel;
    output [6:0] seg;
    reg [2:0] cnt;
    reg [3:0] Dsel;
    wire [6:0] SegWire;

    always @(posedge clk1k or negedge rst) begin
        if (!rst) 
            cnt <= 3'b0;
        else if (cnt == 3'd5)
            cnt <= 3'b0;
        else 
            cnt <= cnt + 1'b1;
    end
    
    always @(*) begin
        case (cnt)
            3'd5: sel = 6'b100000;
            3'd4: sel = 6'b010000;
            3'd3: sel = 6'b001000;
            3'd2: sel = 6'b000100;
            3'd1: sel = 6'b000010;
            3'd0: sel = 6'b000001;  
            default: sel = 6'b000000;
        endcase
    end

    always @(*) begin
        case (cnt)
            3'd0: Dsel = D0;
            3'd1: Dsel = D1;
            3'd2: Dsel = D2;
            3'd3: Dsel = D3;
            3'd4: Dsel = D4;
            3'd5: Dsel = D5;
            default: Dsel = 4'b0;
        endcase
    end

    ToSeg u_ToSeg(.D(Dsel), .seg(SegWire));
    assign seg = SegWire;

endmodule