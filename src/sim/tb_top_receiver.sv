`timescale 1ns/1ps

module tb_top_receiver;

    reg  [7:0] code_in;
    wire [2:0] syndrome;
    wire       global_parity_error;
    wire [7:0] corrected_code;
    wire [3:0] data_out;
    wire       single_error;
    wire       double_error;
    wire       parity_bit_error;
    wire [7:0] seg;

    top_receiver uut (
        .code_in(code_in),
        .syndrome(syndrome),
        .global_parity_error(global_parity_error),
        .corrected_code(corrected_code),
        .data_out(data_out),
        .single_error(single_error),
        .double_error(double_error),
        .parity_bit_error(parity_bit_error),
        .seg(seg)
    );

    initial begin
        $dumpfile("tb_top_receiver.vcd");
        $dumpvars(0, tb_top_receiver);

        // Caso 1: sin error, data = 1010
        code_in = 8'hD2;
        #10;

        // Caso 2: error simple
        code_in = 8'hD6;
        #10;

        // Caso 3: error en paridad global
        code_in = 8'h52;
        #10;

        // Caso 4: doble error
        code_in = 8'hD7;
        #10;

        $finish;
    end

endmodule