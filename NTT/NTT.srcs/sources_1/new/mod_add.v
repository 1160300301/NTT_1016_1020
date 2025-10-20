module mod_add(
    input [11:0] a, b,
    output [11:0] result
);
    parameter Q = 3329;
    
    wire [12:0] sum = a + b;
    wire [12:0] sum_sub_q = sum - Q;
    
    
    assign result = (sum_sub_q[12] == 0) ? sum_sub_q[11:0] : sum[11:0];
endmodule
