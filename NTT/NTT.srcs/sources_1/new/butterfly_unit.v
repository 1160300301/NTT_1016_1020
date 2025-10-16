module butterfly_unit(
    input clk, rst,
    input ct_mode,  // 1: CT����, 0: GS����
    input [11:0] in_a, in_b, twiddle,
    output [11:0] out_even, out_odd
);
    
    // ============================================
    // ��ˮ��1������Ĵ�
    // ============================================
    reg [11:0] in_a_r1, in_b_r1, twiddle_r1;
    reg ct_mode_r1;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            in_a_r1 <= 0;
            in_b_r1 <= 0;
            twiddle_r1 <= 0;
            ct_mode_r1 <= 0;
        end else begin
            in_a_r1 <= in_a;
            in_b_r1 <= in_b;
            twiddle_r1 <= twiddle;
            ct_mode_r1 <= ct_mode;
        end
    end
    
    // ============================================
    // ��ˮ��2������GSģʽ��Ҫ�ļ���
    // ============================================
    wire [11:0] sub_for_gs;
    reg [11:0] mul_input;
    reg [11:0] twiddle_r2;
    reg ct_mode_r2;
    
    mod_sub subtr_gs(
        .a(in_a_r1),
        .b(in_b_r1),
        .result(sub_for_gs)
    );
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mul_input <= 0;
            twiddle_r2 <= 0;
            ct_mode_r2 <= 0;
        end else begin
            mul_input <= ct_mode_r1 ? in_b_r1 : sub_for_gs;
            twiddle_r2 <= twiddle_r1;
            ct_mode_r2 <= ct_mode_r1;
        end
    end
    
    // ============================================
    // ��ˮ��3-7��ģ�ˣ�5���ڣ�
    // ============================================
    wire [11:0] mul_result;
    
    mod_mul mult(
        .clk(clk),
        .rst(rst),
        .a(mul_input),
        .b(twiddle_r2),
        .result(mul_result)
    );
    
    // ============================================
    // �ӳ�������in_a��in_b�ӳ�6����ƥ��˷���
    // (r1 + r2 + mul��5�� = 7�ģ���mul_input�Ѿ�����r2���������ӳ�5��)
    // ============================================
    reg [11:0] in_a_delay [0:5];
    reg [11:0] in_b_delay [0:5];
    reg ct_mode_delay [0:5];
    
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 6; i = i + 1) begin
                in_a_delay[i] <= 0;
                in_b_delay[i] <= 0;
                ct_mode_delay[i] <= 0;
            end
        end else begin
            // ��һ���ӳٴ�r1��ʼ
            in_a_delay[0] <= in_a_r1;
            in_b_delay[0] <= in_b_r1;
            ct_mode_delay[0] <= ct_mode_r1;
            
            // ��������
            for (i = 1; i < 6; i = i + 1) begin
                in_a_delay[i] <= in_a_delay[i-1];
                in_b_delay[i] <= in_b_delay[i-1];
                ct_mode_delay[i] <= ct_mode_delay[i-1];
            end
        end
    end
    
    // ============================================
    // ��ˮ��8�����ռӼ�����
    // ============================================
    wire [11:0] add_input_b, sub_input_b;
    wire [11:0] add_result, sub_result;
    
    assign add_input_b = ct_mode_delay[5] ? mul_result : in_b_delay[5];
    assign sub_input_b = ct_mode_delay[5] ? mul_result : in_b_delay[5];
    
    mod_add adder(
        .a(in_a_delay[5]),
        .b(add_input_b),
        .result(add_result)
    );
    
    mod_sub subtr_final(
        .a(in_a_delay[5]),
        .b(sub_input_b),
        .result(sub_result)
    );
    
    // ============================================
    // ��ˮ��9������Ĵ�
    // ============================================
    reg [11:0] out_even_r, out_odd_r;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out_even_r <= 0;
            out_odd_r <= 0;
        end else begin
            out_even_r <= add_result;
            out_odd_r <= ct_mode_delay[5] ? sub_result : mul_result;
        end
    end
    
    assign out_even = out_even_r;
    assign out_odd = out_odd_r;
    
endmodule