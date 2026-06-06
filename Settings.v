/*
Settings 设置时钟和分钟
Settings.v by ZelongXiao
2026.06.06
*/

module Settings(clk, rst, minAdd, hourAdd, state, s, m, h);
input clk, rst, minAdd, hourAdd;
input [1:0] state;
output reg [5:0] s, m, h;
reg [6:0] cnt100;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        s<=6'd0;
        m<=6'd0;
        h<=6'd0;
        cnt100<=7'd0;
    end
    else if(minAdd) m<=(m==6'd59)? 6'd0 : m+1;
    else if(hourAdd) h<=(h==6'd23)? 6'd0 : h+1;
    else if(state==1 || state==2) cnt100<=7'd0; 
    else begin
        if(cnt100>=7'd99) begin
            cnt100<=7'd0;
            if (s==6'd59) begin
                s<=6'd0;
                if(m==6'd59) begin
                    m<=6'd0;
                    if(h==6'd23) h<=6'd0;
                    else h<=h+1;
                end
                else m<=m+1;
            end
            else s<=s+1;
        end
        else cnt100<=cnt100+1;
    end
end
endmodule