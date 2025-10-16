module address_generator(
    input [2:0] stage,
    input [6:0] loop_cnt,
    output reg [7:0] addr_a, addr_b
);
    // 根据stage和loop计数生成蝶形运算的地址对
    always @(*) begin
        case (stage)
            3'd0: begin // 步长=128
                addr_a = loop_cnt;
                addr_b = loop_cnt + 128;
            end
            3'd1: begin // 步长=64
                addr_a = {loop_cnt[6], loop_cnt[5:0]};
                addr_b = {loop_cnt[6], loop_cnt[5:0]} + 64;
            end
            3'd2: begin // 步长=32
                addr_a = {loop_cnt[6:5], loop_cnt[4:0]};
                addr_b = {loop_cnt[6:5], loop_cnt[4:0]} + 32;
            end
            3'd3: begin // 步长=16
                addr_a = {loop_cnt[6:4], loop_cnt[3:0]};
                addr_b = {loop_cnt[6:4], loop_cnt[3:0]} + 16;
            end
            3'd4: begin // 步长=8
                addr_a = {loop_cnt[6:3], loop_cnt[2:0]};
                addr_b = {loop_cnt[6:3], loop_cnt[2:0]} + 8;
            end
            3'd5: begin // 步长=4
                addr_a = {loop_cnt[6:2], loop_cnt[1:0]};
                addr_b = {loop_cnt[6:2], loop_cnt[1:0]} + 4;
            end
            3'd6: begin // 步长=2
                addr_a = {loop_cnt[6:1], loop_cnt[0]};
                addr_b = {loop_cnt[6:1], loop_cnt[0]} + 2;
            end
            default: begin
                addr_a = 0;
                addr_b = 0;
            end
        endcase
    end
endmodule