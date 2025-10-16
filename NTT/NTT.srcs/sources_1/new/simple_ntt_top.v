module simple_ntt_top(
    input clk, rst,    
    input start,
    input [1:0] operation,
    input [7:0] din_addr,
    input [11:0] din,
    input din_valid,
    output [11:0] dout,
    output done
);
    // RAM实例
    reg [11:0] ram [0:255];
    
    // 控制器输出
    wire [2:0] stage;
    wire [7:0] loop_counter;
    wire [8:0] twiddle_addr;
    
    // 地址生成器输出
    wire [7:0] addr_a, addr_b;
    
    // 数据通路
    wire [11:0] data_a, data_b;
    wire [11:0] twiddle_factor;
    wire [11:0] result_even, result_odd;
    
    // ============================================
    // ? 关键新增：地址延迟链（7级）
    // ============================================
    reg [7:0] addr_a_delay [0:6];
    reg [7:0] addr_b_delay [0:6];
    reg write_enable_delay [0:6];
    
    // 用于判断是否在计算状态
    wire computing;
    assign computing = (ctrl_state == 2'b01) || (ctrl_state == 2'b10);
    
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 7; i = i + 1) begin
                addr_a_delay[i] <= 0;
                addr_b_delay[i] <= 0;
                write_enable_delay[i] <= 0;
            end
        end else begin
            // 第一级
            addr_a_delay[0] <= addr_a;
            addr_b_delay[0] <= addr_b;
            write_enable_delay[0] <= computing && !din_valid;
            
            // 后续级联
            for (i = 1; i < 7; i = i + 1) begin
                addr_a_delay[i] <= addr_a_delay[i-1];
                addr_b_delay[i] <= addr_b_delay[i-1];
                write_enable_delay[i] <= write_enable_delay[i-1];
            end
        end
    end
    
    // ============================================
    // RAM读写逻辑
    // ============================================
    // 读取操作数（当前周期）
    assign data_a = ram[addr_a];
    assign data_b = ram[addr_b];
    
    // ? 写入使用延迟后的地址
    always @(posedge clk) begin
        if (din_valid)
            ram[din_addr] <= din;
        else if (write_enable_delay[6]) begin
            ram[addr_a_delay[6]] <= result_even;
            ram[addr_b_delay[6]] <= result_odd;
        end
    end
    
    // ============================================
    // 模块实例化
    // ============================================
    wire [1:0] ctrl_state;  // 需要从controller暴露状态
    
    ntt_controller ctrl(
        .clk(clk),
        .rst(rst),
        .start(start),
        .operation(operation),
        .stage(stage),
        .loop_counter(loop_counter),
        .twiddle_addr(twiddle_addr),
        .done(done),
        .current_state(ctrl_state)  // ? 新增输出
    );
    
    address_generator addr_gen(
        .stage(stage),
        .loop_cnt(loop_counter[6:0]),
        .addr_a(addr_a),
        .addr_b(addr_b)
    );
    
    butterfly_unit butterfly(
        .clk(clk),
        .rst(rst),
        .ct_mode(operation == 2'b01),
        .in_a(data_a),
        .in_b(data_b),
        .twiddle(twiddle_factor),
        .out_even(result_even),
        .out_odd(result_odd)
    );
    
    twiddle_rom twiddle_inst(
        .clk(clk),
        .addr(twiddle_addr),
        .data(twiddle_factor)
    );
    
    // 输出
    assign dout = ram[din_addr];
    
endmodule