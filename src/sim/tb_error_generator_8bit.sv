`timescale 1ns/1ps

module tb_error_generator_8bit;

    reg  [7:0] code_in;
    reg  [2:0] error_pos;
    reg        error_enable;
    wire [7:0] code_out;

    // Instancia del módulo
    error_generator_8bit uut (
        .code_in(code_in),
        .error_pos(error_pos),
        .error_enable(error_enable),
        .code_out(code_out)
    );

    integer i;

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, tb_error_generator_8bit);

        // Caso 1: sin error
        code_in = 8'b10101010;
        error_enable = 0;
        error_pos = 3'b000;
        #10;

        // Caso 2: recorrer todos los bits con error
        error_enable = 1;
        for (i = 0; i < 8; i = i + 1) begin
            error_pos = i[2:0];
            #10;
        end

        // Caso 3: otro patrón
        code_in = 8'b11110000;
        for (i = 0; i < 8; i = i + 1) begin
            error_pos = i[2:0];
            #10;
        end

        $finish;
    end

endmodule