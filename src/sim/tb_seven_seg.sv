`timescale 1ns/1ps

module tb_seven_seg;

    reg  [3:0] data_in;
    wire [7:0] code_out;

    seven_seg_decoder uut (
        .data_in(data_in),
        .code_out(code_out)
    );

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, tb_seven_seg);

        data_in = 0; #10;
        data_in = 1; #10;
        data_in = 2; #10;
        data_in = 3; #10;
        data_in = 4; #10;
        data_in = 5; #10;
        data_in = 6; #10;
        data_in = 7; #10;
        data_in = 8; #10;
        data_in = 9; #10;

        $finish;
    end

endmodule