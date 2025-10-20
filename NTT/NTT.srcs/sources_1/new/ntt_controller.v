module ntt_controller(
    input clk, rst,
    input start,
    input [1:0] operation,
    output reg [2:0] stage,
    output reg [7:0] loop_counter,
    output reg [8:0] twiddle_addr,
    output reg done,
    output [1:0] current_state
);
    // 状态定义
    localparam IDLE  = 2'b00;
    localparam FNTT  = 2'b01;
    localparam INTT  = 2'b10;
    localparam FLUSH = 2'b11;
    
    reg [1:0] state, next_state;
    reg [2:0] flush_counter;
    
    assign current_state = state;
    
    // 状态寄存器
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    // 状态转换逻辑
    always @(*) begin
        case (state)
            IDLE: begin
                if (start && operation == FNTT)
                    next_state = FNTT;
                else if (start && operation == INTT)
                    next_state = INTT;
                else
                    next_state = IDLE;
            end
            
            FNTT, INTT: begin
                if (stage == 3'd6 && loop_counter == 8'd127)
                    next_state = FLUSH;
                else
                    next_state = state;
            end
            
            FLUSH: begin
                // 修改点 1：等待 8 个周期（0-7），原来是 3'd6
                if (flush_counter >= 3'd7)  // 改这里：3'd6→3'd7
                    next_state = IDLE;
                else
                    next_state = FLUSH;
            end
            
            default: next_state = IDLE;
        endcase
    end
    
    // 计数器和输出逻辑
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            loop_counter <= 0;
            twiddle_addr <= 0;
            done <= 0;
            flush_counter <= 0;
        end 
        else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    flush_counter <= 0;
                    
                    if (start) begin
                        stage <= 0;
                        loop_counter <= 0;
                        twiddle_addr <= (operation == INTT) ? 9'd127 : 9'd0;
                    end
                end
                
                FNTT, INTT: begin
                    // 每个周期推进loop计数器
                    if (loop_counter < 8'd127) begin
                        loop_counter <= loop_counter + 1;
                        twiddle_addr <= twiddle_addr + 1;
                    end 
                    else begin
                        // 完成一个stage
                        loop_counter <= 0;
                        
                        if (stage < 3'd6) begin
                            stage <= stage + 1;
                            twiddle_addr <= twiddle_addr + 1;
                        end
                    end
                end
                
                FLUSH: begin
                    flush_counter <= flush_counter + 1;
                    
                    // 修改点 2：在第 8 个周期（计数到 7）置 done，原来是 3'd6
                    if (flush_counter == 3'd7)  // 改这里：3'd6→3'd7
                        done <= 1;
                end
                
                default: begin
                    stage <= 0;
                    loop_counter <= 0;
                    done <= 0;
                    flush_counter <= 0;
                end
            endcase
        end
    end
    
endmodule
