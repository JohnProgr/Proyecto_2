`timescale 1ns/1ps

module tb_hamming_encoder;

    logic [7:0] data_in;
    logic [12:0] code_out;

    hamming_encoder_8bit uut (
        .data_in(data_in),
        .code_out(code_out)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_hamming_encoder);

        data_in = 8'b00000000; #10;
        data_in = 8'b10101010; #10;
        data_in = 8'b11110000; #10;
        data_in = 8'b11111111; #10;
        data_in = 8'b01010101; #10;

        $finish;
    end

endmodule