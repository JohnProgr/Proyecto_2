`timescale 1ns/1ps

module tb_system_top_direct;

    logic       clk;
    logic       rst_n;
    logic       valid_i;
    logic [5:0] dividend_i;
    logic [3:0] divisor_i;
    logic       select_i;

    logic [6:0] seven;
    logic [3:0] anodo;
    logic       done_o;
    logic       div_zero_o;

    system_top_direct dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .valid_i    (valid_i),
        .dividend_i (dividend_i),
        .divisor_i  (divisor_i),
        .select_i   (select_i),
        .seven      (seven),
        .anodo      (anodo),
        .done_o     (done_o),
        .div_zero_o (div_zero_o)
    );

    always #5 clk = ~clk;

    task automatic apply_operation(
        input logic [5:0] dividend,
        input logic [3:0] divisor,
        input logic [5:0] exp_quotient,
        input logic [3:0] exp_remainder,
        input logic       exp_div_zero
    );
        begin
            @(negedge clk);
            dividend_i = dividend;
            divisor_i  = divisor;
            valid_i    = 1'b1;

            @(negedge clk);
            valid_i = 1'b0;

            wait(done_o == 1'b1);
            #1;

            if (
                dut.quotient  !== exp_quotient  ||
                dut.remainder !== exp_remainder ||
                div_zero_o    !== exp_div_zero
            ) begin
                $display("ERROR: %0d / %0d -> q=%0d r=%0d div0=%b | esperado q=%0d r=%0d div0=%b",
                    dividend, divisor,
                    dut.quotient, dut.remainder, div_zero_o,
                    exp_quotient, exp_remainder, exp_div_zero
                );
            end else begin
                $display("OK: %0d / %0d -> q=%0d r=%0d div0=%b",
                    dividend, divisor,
                    dut.quotient, dut.remainder, div_zero_o
                );
            end

            @(negedge clk);
        end
    endtask

    initial begin
        $dumpfile("tb_system_top.vcd");
        $dumpvars(0, tb_system_top);

        clk        = 1'b0;
        rst_n      = 1'b0;
        valid_i    = 1'b0;
        dividend_i = 6'd0;
        divisor_i  = 4'd0;
        select_i   = 1'b0;

        repeat (3) @(negedge clk);
        rst_n = 1'b1;

        // 15 / 4 = q 3, r 3
        select_i = 1'b0; // mostrar cociente
        apply_operation(6'd15, 4'd4, 6'd3, 4'd3, 1'b0);

        // cambiar a mostrar residuo
        select_i = 1'b1;
        #700000;

        // 63 / 15 = q 4, r 3
        select_i = 1'b0;
        apply_operation(6'd63, 4'd15, 6'd4, 4'd3, 1'b0);

        select_i = 1'b1;
        #700000;

        // 12 / 0 = div_zero
        select_i = 1'b0;
        apply_operation(6'd12, 4'd0, 6'd0, 4'd0, 1'b1);

        $display("Simulacion de system_top finalizada.");
        $finish;
    end

endmodule