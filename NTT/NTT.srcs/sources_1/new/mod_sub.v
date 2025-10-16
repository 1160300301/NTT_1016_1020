module mod_sub(
    input [11:0] a, b,
    output [11:0] result
);
    parameter Q = 3329;
    
    wire signed [12:0] diff = a - b;
    wire signed [12:0] diff_add_q = diff + Q;
    
    // 如果 diff < 0，则加上q
    assign result = (diff[12] == 1) ? diff_add_q[11:0] : diff[11:0];
endmodule