/*
Settings 设置时钟和分钟
Settings.v by ZelongXiao
2026.06.06
*/

module Settings(clk1, rst, minAdd, hourAdd, state, s, m, h);
input clk1, rst, minAdd, hourAdd;
input [1:0] state;
output reg [5:0] s, m, h;

    always @(posedge clk1 or negedge rst) begin
        if (!rst) begin
            s<=6'd0;
            m<=6'd0;
            h<=6'd0;
        end
        else if (minAdd) begin
            m<=(m==6'd59)? 6'd0: m+1;
        end
        else if (hourAdd) begin
            h<=(h==6'd23)? 6'd0: h+1;
        end
        else if(state==1 || state==2) begin
            // 调整模式(暂停计时)
        end
        else begin
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
    end

endmodule