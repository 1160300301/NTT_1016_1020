module mod_mul(
    input clk, rst,
    input [11:0] a, b,
    output [11:0] result
);
    parameter Q = 3329;
    
    // ��ˮ��1������Ĵ�
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
    
    // ��ˮ��2���˷��Ĵ�
    reg [23:0] product;
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            product <= 0;
        else
            product <= a_r * b_r;
    end
    
    // ��ˮ��3-5��BarrettԼ��3���ڣ�
    Barret_Reduce barret_inst(
        .clk(clk),
        .Tbr(product),
        .reset(rst),
        .Rmdr(result)
    );
    
endmodule