`timescale 1ns / 1ps

module simple_ntt_tb();

// 时钟和复位
reg clk;
reg rst;

// 控制信号
reg start;
reg [1:0] operation;
reg [7:0] din_addr;
reg [11:0] din;
reg din_valid;

// 输出信号
wire [11:0] dout;
wire done;

// 测试数据存储
reg [11:0] test_data [0:255];

// 时钟生成：10ns周期 (100MHz)
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// 实例化待测模块
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

// 主测试流程
integer i;

initial begin
    $display("\n========================================");
    $display("  Kyber NTT 测试开始");
    $display("========================================\n");
    
    // 初始化信号
    rst = 1;
    start = 0;
    operation = 0;
    din_addr = 0;
    din = 0;
    din_valid = 0;
    
    // 准备测试数据：简单的递增序列
    for (i = 0; i < 256; i = i + 1) begin
        test_data[i] = i % 3329;
    end
    
    // 复位
    #100;
    rst = 0;
    $display("[%0t] 复位完成", $time);
    #50;
    
    // ========== 测试1：加载数据 ==========
    $display("\n[%0t] === 开始加载测试数据 ===", $time);
    din_valid = 1;
    
    for (i = 0; i < 256; i = i + 1) begin
        din_addr = i;
        din = test_data[i];
        @(posedge clk);
    end
    
    din_valid = 0;
    $display("[%0t] 数据加载完成！", $time);
    #100;
    
    // ========== 测试2：运行正向NTT ==========
    $display("\n[%0t] === 启动正向NTT ===", $time);
    operation = 2'b01;  // FNTT
    start = 1;
    @(posedge clk);
    start = 0;
    
    // 等待完成
    $display("[%0t] 等待NTT完成...", $time);
    wait(done);
    @(posedge clk);
    $display("[%0t] ? 正向NTT完成！", $time);
    #100;
    
    // ========== 测试3：读取结果 ==========
    $display("\n[%0t] === 读取结果 ===", $time);
    $display("前16个结果：");
    
    for (i = 0; i < 16; i = i + 1) begin
        din_addr = i;
        @(posedge clk);
        #1; // 等待组合逻辑稳定
        $display("  dout[%3d] = %h (%d)", i, dout, dout);
    end
    
    $display("\n[%0t] 测试完成！", $time);
    #500;
    
    $display("\n========================================");
    $display("  测试总结");
    $display("  - 数据加载: ?");
    $display("  - FNTT运行: ?");  
    $display("  - 结果读取: ?");
    $display("========================================\n");
    
    $finish;
end

// 超时保护（1ms）
initial begin
    #1000000;
    $display("\n[错误] 测试超时！");
    $finish;
end

// 监控done信号
always @(posedge done) begin
    $display("[%0t] *** DONE信号拉高 ***", $time);
end

endmodule