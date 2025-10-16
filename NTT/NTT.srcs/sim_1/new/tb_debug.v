`timescale 1ns / 1ps

module tb_debug;

    reg clk, rst;
    reg start;
    reg [1:0] operation;
    reg [7:0] din_addr;
    reg [11:0] din;
    reg din_valid;
    wire [11:0] dout;
    wire done;
    
    simple_ntt_top dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .operation(operation),
        .din_addr(din_addr),
        .din(din),
        .din_valid(din_valid),
        .dout(dout),
        .done(done)
    );
    
    initial clk = 0;
    always #10 clk = ~clk;
    
    integer i;
    reg [11:0] output_data [0:255];
    
    initial begin
        $display("========================================");
        $display("NTTӲ�����Բ���");
        $display("========================================");
        
        // ��ʼ��
        rst = 1;
        start = 0;
        operation = 2'b00;
        din_valid = 0;
        din_addr = 0;
        din = 0;
        
        #100;
        rst = 0;
        #100;
        
        //========================================
        // ����1����λ���� [1, 0, 0, ..., 0]
        //========================================
        $display("\n[����1] ����: [1, 0, 0, ..., 0]");
        
        // д������
        din_valid = 1;
        for (i = 0; i < 256; i = i + 1) begin
            din_addr = i;
            din = (i == 0) ? 12'd1 : 12'd0;  // ֻ�е�һ����1
            @(posedge clk);
        end
        din_valid = 0;
        @(posedge clk);
        
        // ����NTT
        operation = 2'b01;  // FNTT
        start = 1;
        @(posedge clk);
        start = 0;
        
        // �ȴ����
        wait(done == 1);
        $display("[ʱ�� %0t] NTT�������", $time);
        @(posedge clk);
        
        // ��ȡ���
        for (i = 0; i < 256; i = i + 1) begin
            din_addr = i;
            @(posedge clk);
            output_data[i] = dout;
        end
        
        // ��ʾ�����ǰ16���͹ؼ�λ�ã�
        $display("\nӲ����������");
        $display("Index |  Value  | Hex  ");
        $display("------|---------|------");
        for (i = 0; i < 16; i = i + 1) begin
            $display("  %3d | %4d    | 0x%03x", i, output_data[i], output_data[i]);
        end
        
        $display("\n����������λ��ת����");
        $display("  [0]   = %4d", output_data[0]);
        $display("  [128] = %4d", output_data[128]);
        $display("  [64]  = %4d", output_data[64]);
        $display("  [192] = %4d", output_data[192]);
        
        // ������
        $display("\n������");
        if (output_data[0] == 1 && output_data[1] == 1 && output_data[2] == 1) begin
            $display("? ���ȫΪ1 - ������ȷ�ı�׼NTT���");
        end else if (output_data[0] == 1) begin
            $display("? ֻ��index 0��1��������ͬ - ������Ҫλ��ת");
        end else begin
            $display("? ���������Ԥ�ڣ���ʾ�������ݣ�");
            for (i = 0; i < 32; i = i + 1) begin
                if (output_data[i] != 0)
                    $display("  [%3d] = %4d", i, output_data[i]);
            end
        end
        
        //========================================
        // ����2��ȫ1����
        //========================================
        $display("\n\n[����2] ����: [1, 1, 1, ..., 1]");
        
        #1000;
        rst = 1;
        #100;
        rst = 0;
        #100;
        
        // д��ȫ1
        din_valid = 1;
        for (i = 0; i < 256; i = i + 1) begin
            din_addr = i;
            din = 12'd1;
            @(posedge clk);
        end
        din_valid = 0;
        @(posedge clk);
        
        // ����NTT
        operation = 2'b01;
        start = 1;
        @(posedge clk);
        start = 0;
        
        wait(done == 1);
        @(posedge clk);
        
        // ��ȡ���
        for (i = 0; i < 256; i = i + 1) begin
            din_addr = i;
            @(posedge clk);
            output_data[i] = dout;
        end
        
        $display("\nӲ����������ǰ16������");
        for (i = 0; i < 16; i = i + 1) begin
            $display("  [%3d] = %4d", i, output_data[i]);
        end
        
        $display("\n������");
        $display("  [0] = %4d (����: 256 �� 0)", output_data[0]);
        
        // �������Ԫ������
        integer nonzero_count = 0;
        for (i = 0; i < 256; i = i + 1) begin
            if (output_data[i] != 0)
                nonzero_count = nonzero_count + 1;
        end
        $display("  ����Ԫ�ظ���: %d / 256", nonzero_count);
        
        if (nonzero_count == 1 && output_data[0] == 256) begin
            $display("? ��ȷ��ȫ1��NTTֻ��DC����");
        end else begin
            $display("? ���������Ԥ��");
        end
        
        $display("\n========================================");
        $display("���Բ������");
        $display("========================================");
        
        $finish;
    end

endmodule