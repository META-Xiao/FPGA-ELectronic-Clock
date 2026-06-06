/*
Div 分频器
div.v by ZelongXiao
2026.06.06
*/


module div(clk, rst, clk1k, clk100, clk1);
input clk, rst;
output clk1k, clk100, clk1;
reg [26: 0] cnt;

always @(posedge clk or negedge rst) begin
	if(!rst) cnt<=26'b0;
	else if(cnt>=26'd49_999_999) cnt<=26'b0;
	else cnt<=cnt+1'b1;
end

assign clk1k = (cnt==26'd49_999)? 1: 0;
assign clk100 = (cnt==26'd499_999)? 1: 0;
assign clk1 = (cnt==26'd49_999_999)? 1: 0;

endmodule




