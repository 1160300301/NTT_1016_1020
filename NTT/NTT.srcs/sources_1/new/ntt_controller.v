module ntt_controller(
    input clk, rst,
    input start,
    input [1:0] operation,
    output reg [2:0] stage,
    output reg [7:0] loop_counter,
    output reg [8:0] twiddle_addr,
    output reg done,
    output [1:0] current_state  // ? ��������¶��ǰ״̬
);

    // ״̬����
    localparam IDLE  = 2'b00;
    localparam FNTT  = 2'b01;
    localparam INTT  = 2'b10;
    localparam FLUSH = 2'b11;  // ? ��������ˮ���ſ�״̬
    
    reg [1:0] state, next_state;
    reg [2:0] flush_counter;  // ? �������ſռ�������0-6��
    
    assign current_state = state;  // ? �����ǰ״̬
    
    // ============================================
    // ״̬�Ĵ���
    // ============================================
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    // ============================================
    // ״̬ת���߼�
    // ============================================
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
                // ? ����Ƿ�������һ�����ݶ�
                if (stage == 3'd6 && loop_counter == 8'd127)
                    next_state = FLUSH;  // �����ſ�״̬
                else
                    next_state = state;
            end
            
            FLUSH: begin
                // ? �ȴ���ˮ���ſգ�7�����ڣ�
                if (flush_counter >= 3'd6)
                    next_state = IDLE;
                else
                    next_state = FLUSH;
            end
            
            default: next_state = IDLE;
        endcase
    end
    
    // ============================================
    // ������������߼�
    // ============================================
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
                    // ÿ�������ƽ�loop������
                    if (loop_counter < 8'd127) begin
                        loop_counter <= loop_counter + 1;
                        twiddle_addr <= twiddle_addr + 1;
                    end 
                    else begin
                        // ���һ��stage
                        loop_counter <= 0;
                        
                        if (stage < 3'd6) begin
                            stage <= stage + 1;
                            twiddle_addr <= twiddle_addr + 1;
                        end
                        // ��������FLUSH״̬
                    end
                end
                
                FLUSH: begin
                    // ? �ȴ���ˮ���ſ�
                    flush_counter <= flush_counter + 1;
                    
                    // �����һ��������done
                    if (flush_counter == 3'd6)
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