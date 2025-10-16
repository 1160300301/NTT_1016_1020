module Barret_Reduce(
    input clk,
    input[23:0] Tbr,
    input reset,
    output reg[11:0] Rmdr
);
    parameter P = 13'd3329;
    parameter MU = 13'd5039;
    
    reg[23:0] Tbr1, Tbr2;
    reg[25:0] tq;
    reg[24:0] tq_mul_p;  // 25λ
    
    // ��һ��
    always@(posedge clk) begin
        if(reset) begin
            tq <= 26'd0;
            Tbr1 <= 24'd0;
        end else begin
            tq <= Tbr[23:11] * MU;
            Tbr1 <= Tbr;
        end
    end
    
    // �ڶ���
    always@(posedge clk) begin
        if(reset) begin
            tq_mul_p <= 25'd0;
            Tbr2 <= 24'd0;
        end else begin
            tq_mul_p <= tq[25:13] * P;
            Tbr2 <= Tbr1;
        end
    end
    
    // ������ - �ؼ��޸ģ�
    wire[24:0] Tbr2_ext;
    wire signed [25:0] r1_signed;  // ? ʹ���з������������
    wire[24:0] r1, r2, r3;
    
    assign Tbr2_ext = {1'b0, Tbr2};
    assign r1_signed = {1'b0, Tbr2_ext} - {1'b0, tq_mul_p};  // 26λ�з��ż���
    
    // ��� r1_signed < 0��˵�� q ̫���ˣ���Ҫ�ӻ�һ�� p
    assign r1 = r1_signed[25] ? (r1_signed + P) : r1_signed[24:0];
    assign r2 = (r1 >= P) ? (r1 - P) : r1;
    assign r3 = (r2 >= P) ? (r2 - P) : r2;
    
    always@(posedge clk) begin
        if(reset)
            Rmdr <= 12'd0;
        else
            Rmdr <= r3[11:0];  // ? �򻯣�����3��������һ����ȷ
    end
    
endmodule