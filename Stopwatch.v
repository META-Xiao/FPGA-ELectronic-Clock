/*
Stopwatch timing 跑表计时
    State: 0-Stop 1-Running
    0->1, 1->0 Key1 press
    reset or Key2 press to clear
Stopwatch.v by ZelongXiao
2026.06.06
*/

module Stopwatch(clk100, rst, key1, key2, s, m, h);
input clk100, rst, key1, key2;
output reg [5:0] s, m, h;

    reg key1La, key2La;
    wire key1In = ~key1;
    wire key2In = ~key2;
    wire key1Pulse = key1In & ~key1La;
    wire key2Pulse = key2In & ~key2La;
    reg state;
    reg [6:0] cnt100;

    always @(posedge clk100 or negedge rst) begin
        if(!rst) begin
            key1La <= 0;
            key2La <= 0;
        end
        else begin
            key1La <= key1In;
            key2La <= key2In;
        end
    end

    always @(posedge clk100 or negedge rst) begin
        if(!rst) begin
            state  <= 0;
            s <= 0; 
            m <= 0; 
            h <= 0;
            cnt100 <= 0;
        end
        else begin
            if(key2Pulse) begin
                s <= 0; 
                m <= 0; 
                h <= 0;
                cnt100 <= 0;
            end
            else if(key1Pulse) begin
                state <= ~state;
            end
            else if(state) begin
                if(cnt100 == 99) begin
                    cnt100 <= 0;
                    if(s == 59) begin
                        s <= 0;
                        if(m == 59) begin
                            m <= 0;
                            if(h == 23) h <= 0;
                            else h <= h + 1;
                        end
                        else m <= m + 1;
                    end
                    else s <= s + 1;
                end
                else cnt100 <= cnt100 + 1;
            end
        end
    end

endmodule