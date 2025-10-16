`timescale 1ns / 1ps

module tb_ntt_pipeline;
    
    reg clk, rst, start;
    reg [1:0] operation;
    reg [7:0] din_addr;
    reg [11:0] din;
    reg din_valid;
    wire [11:0] dout;
    wire done;
    
    // ʵ����DUT
    simple_ntt_top uut(
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
    
    // ʱ�����ɣ�10ns���� = 100MHz
    initial clk = 0;
    always #5 clk = ~clk;
    
    // ��������
    integer i;
    initial begin
        // ��ʼ��
        rst = 1;
        start = 0;
        operation = 2'b00;
        din_valid = 0;
        din_addr = 0;
        din = 0;
        
        // ��λ
        #50 rst = 0;
        $display("=== ��ʼ���� ===");
        
        // ========================================
        // �׶�1��д���������
        // ========================================
        $display("[%0t] д���������...", $time);
        din_valid = 1;
        for (i = 0; i < 256; i = i + 1) begin
            din_addr = i;
            din = i % 256;  // �򵥲�������
            @(posedge clk);
        end
        din_valid = 0;
        $display("[%0t] ����д�����", $time);
        
        // �ȴ���������
        repeat(10) @(posedge clk);
        
        // ========================================
        // �׶�2����������NTT
        // ========================================
        $display("[%0t] ��������NTT...", $time);
        operation = 2'b01;  // FNTT
        start = 1;
        @(posedge clk);
        start = 0;
        
        // �ȴ����
        wait(done);
        $display("[%0t] ? ����NTT��ɣ�", $time);
        
        // �ȴ���������
        repeat(10) @(posedge clk);
        
        // ========================================
        // �׶�3����������NTT
        // ========================================
        $display("[%0t] ��������NTT...", $time);
        operation = 2'b10;  // INTT
        start = 1;
        @(posedge clk);
        start = 0;
        
        // �ȴ����
        wait(done);
        $display("[%0t] ? ����NTT��ɣ�", $time);
        
        // ========================================
        // �׶�4�����������֤
        // ========================================
        $display("[%0t] ��֤���...", $time);
        repeat(10) @(posedge clk);
        
        din_valid = 0;
        for (i = 0; i < 10; i = i + 1) begin
            din_addr = i;
            @(posedge clk);
            @(posedge clk);  // �ȴ�����
            $display("  ram[%0d] = %0d (������%0d)", i, dout, i % 256);
        end
        
        $display("=== ������� ===");
        #100 $finish;
    end
    
    // ���ܼ��
    integer start_time, end_time;
    always @(posedge start) begin
        start_time = $time;
    end
    
    always @(posedge done) begin
        end_time = $time;
        $display("[����] NTT��ʱ: %0d ns = %0d ����", 
                 end_time - start_time, 
                 (end_time - start_time) / 10);
    end
    
    // ��ʱ���
    initial begin
        #1000000;  // 1ms��ʱ
        $error("? ���Գ�ʱ��");
        $finish;
    end
    
endmodule