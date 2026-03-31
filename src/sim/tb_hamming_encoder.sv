`timescale 1ns/1ps

module tb_hamming_encoder;

    reg [3:0] data_in;
    wire [7:0] code_out;

    hamming_encoder uut (
        .data_in(data_in),
        .code_out(code_out)
    );

    initial begin
        data_in = 4'b0000;
        #10;

        data_in = 4'b0001;
        #10;

        data_in = 4'b0010;
        #10;

        data_in = 4'b0011;
        #10;

        data_in = 4'b0100;
        #10;

        data_in = 4'b0101;
        #10;

        data_in = 4'b0111;
        #10;

        data_in = 4'b1001;
        #10;

        data_in = 4'b1010;
        #10;

        data_in = 4'b1111;
        #10;

        $finish;
    end

    initial begin
        $monitor("time=%0t | data_in=%b | code_out=%b", $time, data_in, code_out);
    end

endmodule