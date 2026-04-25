`timescale 1ns/1ps

module tb_top_system;

    reg  [3:0] data_in;
    reg        error_enable;
    reg  [2:0] error_pos;

    wire [7:0] tx_code;
    wire [7:0] corrected_code;
    wire [3:0] data_out;
    wire [2:0] syndrome;
    wire       global_parity_error;
    wire       single_error;
    wire       double_error;
    wire       parity_bit_error;
    wire [7:0] seg_tx;
    wire [7:0] seg_rx;

    top_system uut (
        .data_in(data_in),
        .error_enable(error_enable),
        .error_pos(error_pos),
        .tx_code(tx_code),
        .corrected_code(corrected_code),
        .data_out(data_out),
        .syndrome(syndrome),
        .global_parity_error(global_parity_error),
        .single_error(single_error),
        .double_error(double_error),
        .parity_bit_error(parity_bit_error),
        .seg_tx(seg_tx),
        .seg_rx(seg_rx)
    );

    initial begin
        $dumpfile("tb_top_system.vcd");
        $dumpvars(0, tb_top_system);

        // Caso 1: sin error
        data_in = 4'b1010;
        error_enable = 1'b0;
        error_pos = 3'b000;
        #10;

        // Caso 2: error simple en un bit
        data_in = 4'b1010;
        error_enable = 1'b1;
        error_pos = 3'b010;
        #10;

        // Caso 3: error en paridad global
        data_in = 4'b1010;
        error_enable = 1'b1;
        error_pos = 3'b111;
        #10;

        // Caso 4: otra palabra sin error
        data_in = 4'b0110;
        error_enable = 1'b0;
        error_pos = 3'b000;
        #10;

        $finish;
    end

endmodule