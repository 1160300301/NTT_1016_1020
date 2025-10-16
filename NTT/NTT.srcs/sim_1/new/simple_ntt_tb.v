`timescale 1ns / 1ps

module simple_ntt_tb();

// ʱ�Ӻ͸�λ
reg clk;
reg rst;

// �����ź�
reg start;
reg [1:0] operation;
reg [7:0] din_addr;
reg [11:0] din;
reg din_valid;

// ����ź�
wire [11:0] dout;
wire done;

// �������ݴ洢
reg [11:0] test_data [0:255];

// ʱ�����ɣ�10ns���� (100MHz)
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// ʵ��������ģ��
simple_ntt_top dut(
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

// ����������
integer i;

initial begin
    $display("\n========================================");
    $display("  Kyber NTT ���Կ�ʼ");
    $display("========================================\n");
    
    // ��ʼ���ź�
    rst = 1;
    start = 0;
    operation = 0;
    din_addr = 0;
    din = 0;
    din_valid = 0;
    
    // ׼���������ݣ��򵥵ĵ�������
    for (i = 0; i < 256; i = i + 1) begin
        test_data[i] = i % 3329;
    end
    
    // ��λ
    #100;
    rst = 0;
    $display("[%0t] ��λ���", $time);
    #50;
    
    // ========== ����1���������� ==========
    $display("\n[%0t] === ��ʼ���ز������� ===", $time);
    din_valid = 1;
    
    for (i = 0; i < 256; i = i + 1) begin
        din_addr = i;
        din = test_data[i];
        @(posedge clk);
    end
    
    din_valid = 0;
    $display("[%0t] ���ݼ�����ɣ�", $time);
    #100;
    
    // ========== ����2����������NTT ==========
    $display("\n[%0t] === ��������NTT ===", $time);
    operation = 2'b01;  // FNTT
    start = 1;
    @(posedge clk);
    start = 0;
    
    // �ȴ����
    $display("[%0t] �ȴ�NTT���...", $time);
    wait(done);
    @(posedge clk);
    $display("[%0t] ? ����NTT��ɣ�", $time);
    #100;
    
    // ========== ����3����ȡ��� ==========
    $display("\n[%0t] === ��ȡ��� ===", $time);
    $display("ǰ16�������");
    
    for (i = 0; i < 16; i = i + 1) begin
        din_addr = i;
        @(posedge clk);
        #1; // �ȴ�����߼��ȶ�
        $display("  dout[%3d] = %h (%d)", i, dout, dout);
    end
    
    $display("\n[%0t] ������ɣ�", $time);
    #500;
    
    $display("\n========================================");
    $display("  �����ܽ�");
    $display("  - ���ݼ���: ?");
    $display("  - FNTT����: ?");  
    $display("  - �����ȡ: ?");
    $display("========================================\n");
    
    $finish;
end

// ��ʱ������1ms��
initial begin
    #1000000;
    $display("\n[����] ���Գ�ʱ��");
    $finish;
end

// ���done�ź�
always @(posedge done) begin
    $display("[%0t] *** DONE�ź����� ***", $time);
end

endmodule