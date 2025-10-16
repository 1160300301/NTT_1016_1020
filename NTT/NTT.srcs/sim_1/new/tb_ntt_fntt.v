`timescale 1ns / 1ps

module tb_ntt_fntt;

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
    
    // ʵ����DUT
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
    
    // ʱ�����ɣ�50MHz (20ns����)
    initial clk = 0;
    always #10 clk = ~clk;
    
    // �������ݴ洢��5�����������
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
    
    // Ӳ���������
    reg [11:0] hardware_output [0:255];
    
    initial begin
        `include "test_vectors_fntt.vh"
    end
    
    
    // ����
    integer i, errors;
    integer total_errors;
    
    //======================================
    // ����д�����ݵ�Ӳ��
    //======================================
    task write_input_data;
        input integer case_id;
        integer j;
        begin
            $display("[%0t] д��������� %0d ����������...", $time, case_id);
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
            $display("[%0t] ��������д�����", $time);
        end
    endtask
    
    //======================================
    // ��������FNTT����
    //======================================
    task start_fntt;
        begin
            $display("[%0t] ��������NTT����...", $time);
            operation = 2'b01;  // FNTT
            start = 1;
            @(posedge clk);
            start = 0;
            
            // �ȴ�����ź�
            wait(done == 1);
            $display("[%0t] NTT������ɣ���ʱ��%0d ��ʱ������", 
                     $time, ($time/20) - 2);  // ��ȥ��ʼ��ʱ��
            @(posedge clk);
        end
    endtask
    
    //======================================
    // ���񣺶�ȡӲ�����
    //======================================
    task read_output_data;
        integer j;
        begin
            $display("[%0t] ��ȡӲ���������...", $time);
            for (j = 0; j < 256; j = j + 1) begin
                din_addr = j;
                @(posedge clk);
                hardware_output[j] = dout;
            end
            $display("[%0t] ������ݶ�ȡ���", $time);
        end
    endtask
    
    //======================================
    // ���񣺱ȽϽ��
    //======================================
    task verify_results;
        input integer case_id;
        integer j;
        reg [11:0] expected;
        begin
            errors = 0;
            $display("\n========================================");
            $display("��֤�������� %0d", case_id);
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
                    // ֻ��ӡǰ10������
                    if (errors <= 10) begin
                        $display("  [ERROR] Index %3d: Expected = %4d, Got = %4d, Diff = %4d",
                                j, expected, hardware_output[j], 
                                (hardware_output[j] - expected));
                    end
                end
            end
            
            if (errors == 0) begin
                $display("? �������� %0d ͨ��������256����ƥ�䡣", case_id);
            end else begin
                $display("? �������� %0d ʧ�ܣ����� %0d ������", case_id, errors);
                if (errors > 10) begin
                    $display("  (ֻ��ʾǰ10������)");
                end
            end
            
            total_errors = total_errors + errors;
        end
    endtask
    
    //======================================
    // �������е�����������
    //======================================
    task run_test_case;
        input integer case_id;
        begin
            $display("\n");
            $display("****************************************");
            $display("���в������� %0d", case_id);
            $display("****************************************");
            
            // 1. д����������
            write_input_data(case_id);
            
            // 2. ����FNTT
            start_fntt();
            
            // 3. ��ȡ���
            read_output_data();
            
            // 4. ��֤���
            verify_results(case_id);
        end
    endtask
    
    //======================================
    // ����������
    //======================================
    initial begin
        // ��ʼ���ź�
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
        $display("       NTT����任��֤���Կ�ʼ");
        $display("================================================");
        $display("ʱ��Ƶ��: 50 MHz");
        $display("Ԥ��ÿ��NTT��ʱ: 896 ʱ������");
        $display("������������: 5");
        $display("================================================");
        
        // ��λ
        #100;
        rst = 0;
        #100;
        
        // �������в�������
        run_test_case(0);  // ȫ��
        #200;
        
        run_test_case(1);  // ��λ����
        #200;
        
        run_test_case(2);  // ȫ1
        #200;
        
        run_test_case(3);  // ��������
        #200;
        
        run_test_case(4);  // �������
        #200;
        
        // ���ձ���
        $display("\n");
        $display("================================================");
        $display("           �������");
        $display("================================================");
        $display("�ܲ�������: 5");
        $display("�ܴ�����: %0d", total_errors);
        
        if (total_errors == 0) begin
            $display("״̬: ȫ��ͨ�� ???");
        end else begin
            $display("״̬: ���ڴ��� ???");
        end
        $display("================================================");
        
        $finish;
    end
    
    // ��ʱ��������ֹ���濨����
    initial begin
        #500000000;  // 500ms ��ʱ
        $display("\n[ERROR] ���泬ʱ��");
        $finish;
    end
    
    // ��ѡ�����ɲ����ļ�
    initial begin
        $dumpfile("tb_ntt_fntt.vcd");
        $dumpvars(0, tb_ntt_fntt);
    end

endmodule