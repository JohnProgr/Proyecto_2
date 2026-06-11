`timescale 1ns/1ps

module tb_display_result_controller;

    logic clk;
    logic rst_n;

    logic [5:0] quotient_i;
    logic [3:0] remainder_i;
    logic       select_i;

    logic [6:0] seven;
    logic [3:0] anodo;

    display_result_controller dut (
        .clk         (clk),
        .rst_n       (rst_n),
        .quotient_i  (quotient_i),
        .remainder_i (remainder_i),
        .select_i    (select_i),
        .seven       (seven),
        .anodo       (anodo)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_display_result_controller.vcd");
        $dumpvars(0, tb_display_result_controller);

        clk = 1'b0;
        rst_n = 1'b0;

        quotient_i = 6'd0;
        remainder_i = 4'd0;
        select_i = 1'b0;

        #20;
        rst_n = 1'b1;

        // Caso 1: mostrar cociente 5
        quotient_i = 6'd5;
        remainder_i = 4'd0;
        select_i = 1'b0;
        #700000;

        // Caso 2: mostrar residuo 3
        quotient_i = 6'd3;
        remainder_i = 4'd3;
        select_i = 1'b1;
        #700000;

        // Caso 3: mostrar cociente 63
        quotient_i = 6'd63;
        remainder_i = 4'd2;
        select_i = 1'b0;
        #700000;

        // Caso 4: mostrar residuo 14
        quotient_i = 6'd10;
        remainder_i = 4'd14;
        select_i = 1'b1;
        #700000;

        $display("Simulacion de display_result_controller finalizada.");
        $finish;
    end

endmodule