`timescale 1ns/1ps

module tb_input_controller;

    logic       clk;
    logic       rst_n;
    logic [3:0] key_value_i;
    logic       key_valid_i;

    logic [5:0] dividend_o;
    logic [3:0] divisor_o;
    logic       valid_o;

    input_controller dut (
        .clk         (clk),
        .rst_n       (rst_n),
        .key_value_i (key_value_i),
        .key_valid_i (key_valid_i),
        .dividend_o  (dividend_o),
        .divisor_o   (divisor_o),
        .valid_o     (valid_o)
    );

    always #5 clk = ~clk;

    task automatic press_key(input logic [3:0] key);
        begin
            @(negedge clk);
            key_value_i = key;
            key_valid_i = 1'b1;

            @(negedge clk);
            key_valid_i = 1'b0;
            key_value_i = 4'd0;
        end
    endtask

    task automatic check_operation(
        input logic [5:0] exp_dividend,
        input logic [3:0] exp_divisor
    );
        begin
            wait(valid_o == 1'b1);
            #1;

            if (dividend_o !== exp_dividend || divisor_o !== exp_divisor) begin
                $display("ERROR: dividend=%0d divisor=%0d | esperado dividend=%0d divisor=%0d",
                    dividend_o, divisor_o, exp_dividend, exp_divisor);
            end else begin
                $display("OK: dividend=%0d divisor=%0d",
                    dividend_o, divisor_o);
            end
        end
    endtask

    initial begin
        $dumpfile("tb_input_controller.vcd");
        $dumpvars(0, tb_input_controller);

        clk = 1'b0;
        rst_n = 1'b0;
        key_value_i = 4'd0;
        key_valid_i = 1'b0;

        repeat (3) @(negedge clk);
        rst_n = 1'b1;

        // Caso 1: 63 / 15
        press_key(4'd6);
        press_key(4'd3);
        press_key(4'hF); // #
        press_key(4'd1);
        press_key(4'd5);
        press_key(4'hF); // #
        check_operation(6'd63, 4'd15);

        // Caso 2: 7 / 3
        press_key(4'd7);
        press_key(4'hF); // #
        press_key(4'd3);
        press_key(4'hF); // #
        check_operation(6'd7, 4'd3);

        // Caso 3: borrar con *
        press_key(4'd4);
        press_key(4'hE); // *
        press_key(4'd8);
        press_key(4'hF); // #
        press_key(4'd2);
        press_key(4'hF); // #
        check_operation(6'd8, 4'd2);

        $display("Simulacion de input_controller finalizada.");
        $finish;
    end

endmodule