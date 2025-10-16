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
        $display("NTT硬件调试测试");
        $display("========================================");
        
        // 初始化
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
        // 测试1：单位脉冲 [1, 0, 0, ..., 0]
        //========================================
        $display("\n[测试1] 输入: [1, 0, 0, ..., 0]");
        
        // 写入数据
        din_valid = 1;
        for (i = 0; i < 256; i = i + 1) begin
            din_addr = i;
            din = (i == 0) ? 12'd1 : 12'd0;  // 只有第一个是1
            @(posedge clk);
        end
        din_valid = 0;
        @(posedge clk);
        
        // 启动NTT
        operation = 2'b01;  // FNTT
        start = 1;
        @(posedge clk);
        start = 0;
        
        // 等待完成
        wait(done == 1);
        $display("[时间 %0t] NTT计算完成", $time);
        @(posedge clk);
        
        // 读取输出
        for (i = 0; i < 256; i = i + 1) begin
            din_addr = i;
            @(posedge clk);
            output_data[i] = dout;
        end
        
        // 显示结果（前16个和关键位置）
        $display("\n硬件输出结果：");
        $display("Index |  Value  | Hex  ");
        $display("------|---------|------");
        for (i = 0; i < 16; i = i + 1) begin
            $display("  %3d | %4d    | 0x%03x", i, output_data[i], output_data[i]);
        end
        
        $display("\n特殊索引（位反转）：");
        $display("  [0]   = %4d", output_data[0]);
        $display("  [128] = %4d", output_data[128]);
        $display("  [64]  = %4d", output_data[64]);
        $display("  [192] = %4d", output_data[192]);
        
        // 检查规律
        $display("\n分析：");
        if (output_data[0] == 1 && output_data[1] == 1 && output_data[2] == 1) begin
            $display("? 输出全为1 - 这是正确的标准NTT输出");
        end else if (output_data[0] == 1) begin
            $display("? 只有index 0是1，其他不同 - 可能需要位反转");
        end else begin
            $display("? 输出不符合预期，显示更多数据：");
            for (i = 0; i < 32; i = i + 1) begin
                if (output_data[i] != 0)
                    $display("  [%3d] = %4d", i, output_data[i]);
            end
        end
        
        //========================================
        // 测试2：全1输入
        //========================================
        $display("\n\n[测试2] 输入: [1, 1, 1, ..., 1]");
        
        #1000;
        rst = 1;
        #100;
        rst = 0;
        #100;
        
        // 写入全1
        din_valid = 1;
        for (i = 0; i < 256; i = i + 1) begin
            din_addr = i;
            din = 12'd1;
            @(posedge clk);
        end
        din_valid = 0;
        @(posedge clk);
        
        // 启动NTT
        operation = 2'b01;
        start = 1;
        @(posedge clk);
        start = 0;
        
        wait(done == 1);
        @(posedge clk);
        
        // 读取输出
        for (i = 0; i < 256; i = i + 1) begin
            din_addr = i;
            @(posedge clk);
            output_data[i] = dout;
        end
        
        $display("\n硬件输出结果（前16个）：");
        for (i = 0; i < 16; i = i + 1) begin
            $display("  [%3d] = %4d", i, output_data[i]);
        end
        
        $display("\n分析：");
        $display("  [0] = %4d (期望: 256 或 0)", output_data[0]);
        
        // 计算非零元素数量
        integer nonzero_count = 0;
        for (i = 0; i < 256; i = i + 1) begin
            if (output_data[i] != 0)
                nonzero_count = nonzero_count + 1;
        end
        $display("  非零元素个数: %d / 256", nonzero_count);
        
        if (nonzero_count == 1 && output_data[0] == 256) begin
            $display("? 正确！全1的NTT只有DC分量");
        end else begin
            $display("? 输出不符合预期");
        end
        
        $display("\n========================================");
        $display("调试测试完成");
        $display("========================================");
        
        $finish;
    end

endmodule