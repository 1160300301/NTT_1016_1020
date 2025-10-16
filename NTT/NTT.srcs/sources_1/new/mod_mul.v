module mod_mul(
    input clk, rst,
    input [11:0] a, b,
    output [11:0] result
);
    parameter Q = 3329;
    
    // 流水级1：输入寄存
    reg [11:0] a_r, b_r;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_r <= 0;
            b_r <= 0;
        end else begin
            a_r <= a;
            b_r <= b;
        end
    end
    
    // 流水级2：乘法寄存
    reg [23:0] product;
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            product <= 0;
        else
            product <= a_r * b_r;
    end
    
    // 流水级3-5：Barrett约简（3周期）
    Barret_Reduce barret_inst(
        .clk(clk),
        .Tbr(product),
        .reset(rst),
        .Rmdr(result)
    );
    
endmodule