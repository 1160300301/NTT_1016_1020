`timescale 1ns / 1ps

module tb_ntt_fntt;

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
    
    // 实例化DUT
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
    
    // 时钟生成：50MHz (20ns周期)
    initial clk = 0;
    always #10 clk = ~clk;
    
    // 测试数据存储（5组测试用例）
    reg [11:0] test_input_0 [0:255];
    reg [11:0] expected_output_0 [0:255];
    
    reg [11:0] test_input_1 [0:255];
    reg [11:0] expected_output_1 [0:255];
    
    reg [11:0] test_input_2 [0:255];
    reg [11:0] expected_output_2 [0:255];
    
    reg [11:0] test_input_3 [0:255];
    reg [11:0] expected_output_3 [0:255];
    
    reg [11:0] test_input_4 [0:255];
    reg [11:0] expected_output_4 [0:255];
    
    // 硬件输出缓存
    reg [11:0] hardware_output [0:255];
    
    initial begin
        `include "test_vectors_fntt.vh"
    end
    
    
    // 变量
    integer i, errors;
    integer total_errors;
    
    //======================================
    // 任务：写入数据到硬件
    //======================================
    task write_input_data;
        input integer case_id;
        integer j;
        begin
            $display("[%0t] 写入测试用例 %0d 的输入数据...", $time, case_id);
            din_valid = 1;
            for (j = 0; j < 256; j = j + 1) begin
                din_addr = j;
                case (case_id)
                    0: din = test_input_0[j];
                    1: din = test_input_1[j];
                    2: din = test_input_2[j];
                    3: din = test_input_3[j];
                    4: din = test_input_4[j];
                    default: din = 0;
                endcase
                @(posedge clk);
            end
            din_valid = 0;
            $display("[%0t] 输入数据写入完成", $time);
        end
    endtask
    
    //======================================
    // 任务：启动FNTT计算
    //======================================
    task start_fntt;
        begin
            $display("[%0t] 启动正向NTT计算...", $time);
            operation = 2'b01;  // FNTT
            start = 1;
            @(posedge clk);
            start = 0;
            
            // 等待完成信号
            wait(done == 1);
            $display("[%0t] NTT计算完成！耗时：%0d 个时钟周期", 
                     $time, ($time/20) - 2);  // 减去初始化时间
            @(posedge clk);
        end
    endtask
    
    //======================================
    // 任务：读取硬件输出
    //======================================
    task read_output_data;
        integer j;
        begin
            $display("[%0t] 读取硬件输出数据...", $time);
            for (j = 0; j < 256; j = j + 1) begin
                din_addr = j;
                @(posedge clk);
                hardware_output[j] = dout;
            end
            $display("[%0t] 输出数据读取完成", $time);
        end
    endtask
    
    //======================================
    // 任务：比较结果
    //======================================
    task verify_results;
        input integer case_id;
        integer j;
        reg [11:0] expected;
        begin
            errors = 0;
            $display("\n========================================");
            $display("验证测试用例 %0d", case_id);
            $display("========================================");
            
            for (j = 0; j < 256; j = j + 1) begin
                case (case_id)
                    0: expected = expected_output_0[j];
                    1: expected = expected_output_1[j];
                    2: expected = expected_output_2[j];
                    3: expected = expected_output_3[j];
                    4: expected = expected_output_4[j];
                    default: expected = 0;
                endcase
                
                if (hardware_output[j] !== expected) begin
                    errors = errors + 1;
                    // 只打印前10个错误
                    if (errors <= 10) begin
                        $display("  [ERROR] Index %3d: Expected = %4d, Got = %4d, Diff = %4d",
                                j, expected, hardware_output[j], 
                                (hardware_output[j] - expected));
                    end
                end
            end
            
            if (errors == 0) begin
                $display("? 测试用例 %0d 通过！所有256个点匹配。", case_id);
            end else begin
                $display("? 测试用例 %0d 失败！发现 %0d 个错误。", case_id, errors);
                if (errors > 10) begin
                    $display("  (只显示前10个错误)");
                end
            end
            
            total_errors = total_errors + errors;
        end
    endtask
    
    //======================================
    // 任务：运行单个测试用例
    //======================================
    task run_test_case;
        input integer case_id;
        begin
            $display("\n");
            $display("****************************************");
            $display("运行测试用例 %0d", case_id);
            $display("****************************************");
            
            // 1. 写入输入数据
            write_input_data(case_id);
            
            // 2. 启动FNTT
            start_fntt();
            
            // 3. 读取输出
            read_output_data();
            
            // 4. 验证结果
            verify_results(case_id);
        end
    endtask
    
    //======================================
    // 主测试流程
    //======================================
    initial begin
        // 初始化信号
        clk = 0;
        rst = 1;
        start = 0;
        operation = 2'b00;
        din_addr = 0;
        din = 0;
        din_valid = 0;
        total_errors = 0;
        
        $display("\n");
        $display("================================================");
        $display("       NTT正向变换验证测试开始");
        $display("================================================");
        $display("时钟频率: 50 MHz");
        $display("预期每次NTT耗时: 896 时钟周期");
        $display("测试用例数量: 5");
        $display("================================================");
        
        // 复位
        #100;
        rst = 0;
        #100;
        
        // 运行所有测试用例
        run_test_case(0);  // 全零
        #200;
        
        run_test_case(1);  // 单位脉冲
        #200;
        
        run_test_case(2);  // 全1
        #200;
        
        run_test_case(3);  // 递增序列
        #200;
        
        run_test_case(4);  // 随机数据
        #200;
        
        // 最终报告
        $display("\n");
        $display("================================================");
        $display("           测试完成");
        $display("================================================");
        $display("总测试用例: 5");
        $display("总错误数: %0d", total_errors);
        
        if (total_errors == 0) begin
            $display("状态: 全部通过 ???");
        end else begin
            $display("状态: 存在错误 ???");
        end
        $display("================================================");
        
        $finish;
    end
    
    // 超时保护（防止仿真卡死）
    initial begin
        #500000000;  // 500ms 超时
        $display("\n[ERROR] 仿真超时！");
        $finish;
    end
    
    // 可选：生成波形文件
    initial begin
        $dumpfile("tb_ntt_fntt.vcd");
        $dumpvars(0, tb_ntt_fntt);
    end

endmodule