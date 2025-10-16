`timescale 1ns / 1ps

module tb_ntt_pipeline;
    
    reg clk, rst, start;
    reg [1:0] operation;
    reg [7:0] din_addr;
    reg [11:0] din;
    reg din_valid;
    wire [11:0] dout;
    wire done;
    
    // 实例化DUT
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
    
    // 时钟生成：10ns周期 = 100MHz
    initial clk = 0;
    always #5 clk = ~clk;
    
    // 测试序列
    integer i;
    initial begin
        // 初始化
        rst = 1;
        start = 0;
        operation = 2'b00;
        din_valid = 0;
        din_addr = 0;
        din = 0;
        
        // 复位
        #50 rst = 0;
        $display("=== 开始测试 ===");
        
        // ========================================
        // 阶段1：写入测试数据
        // ========================================
        $display("[%0t] 写入测试数据...", $time);
        din_valid = 1;
        for (i = 0; i < 256; i = i + 1) begin
            din_addr = i;
            din = i % 256;  // 简单测试数据
            @(posedge clk);
        end
        din_valid = 0;
        $display("[%0t] 数据写入完成", $time);
        
        // 等待几个周期
        repeat(10) @(posedge clk);
        
        // ========================================
        // 阶段2：启动正向NTT
        // ========================================
        $display("[%0t] 启动正向NTT...", $time);
        operation = 2'b01;  // FNTT
        start = 1;
        @(posedge clk);
        start = 0;
        
        // 等待完成
        wait(done);
        $display("[%0t] ? 正向NTT完成！", $time);
        
        // 等待几个周期
        repeat(10) @(posedge clk);
        
        // ========================================
        // 阶段3：启动逆向NTT
        // ========================================
        $display("[%0t] 启动逆向NTT...", $time);
        operation = 2'b10;  // INTT
        start = 1;
        @(posedge clk);
        start = 0;
        
        // 等待完成
        wait(done);
        $display("[%0t] ? 逆向NTT完成！", $time);
        
        // ========================================
        // 阶段4：读出结果验证
        // ========================================
        $display("[%0t] 验证结果...", $time);
        repeat(10) @(posedge clk);
        
        din_valid = 0;
        for (i = 0; i < 10; i = i + 1) begin
            din_addr = i;
            @(posedge clk);
            @(posedge clk);  // 等待读出
            $display("  ram[%0d] = %0d (期望≈%0d)", i, dout, i % 256);
        end
        
        $display("=== 测试完成 ===");
        #100 $finish;
    end
    
    // 性能监控
    integer start_time, end_time;
    always @(posedge start) begin
        start_time = $time;
    end
    
    always @(posedge done) begin
        end_time = $time;
        $display("[性能] NTT耗时: %0d ns = %0d 周期", 
                 end_time - start_time, 
                 (end_time - start_time) / 10);
    end
    
    // 超时检测
    initial begin
        #1000000;  // 1ms超时
        $error("? 测试超时！");
        $finish;
    end
    
endmodule