/*
MainClock 设置时钟和分钟
MainClock.v by ZelongXiao
2026.06.06
*/

module MainClock(clk100, rst, minAdd, hourAdd, minSub, hourSub, state, s, m, h);
input clk100, rst, minAdd, hourAdd, minSub, hourSub;
input [1:0] state;
output reg [5:0] s, m, h;
reg [6:0] cnt100;

always @(posedge clk100 or negedge rst) begin
    if (!rst) begin
        s<=0;
        m<=0;
        h<=0;
        cnt100<=0;
    end
    else if(minAdd) m<=(m==59)? 0 : m+1;
    else if(hourAdd) h<=(h==23)? 0 : h+1;
    else if(minSub) m<=(m==0)? 59 : m-1;
    else if(hourSub) h<=(h==0)? 23 : h-1;
    else if(state==1 || state==2) cnt100<=0; 
    else begin
        if(cnt100>=99) begin
            cnt100<=0;
            if (s==59) begin
                s<=0;
                if(m==59) begin
                    m<=0;
                    if(h==23) h<=0;
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