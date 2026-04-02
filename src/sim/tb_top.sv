`timescale 1ns/1ps

module tb_top;

    reg  [3:0] data_in;
    reg  [2:0] error_pos;
    reg        error_enable;
    wire [7:0] code_out;
    wire [7:0] display;

    top uut (
        .data_in(data_in),
        .error_pos(error_pos),
        .error_enable(error_enable),
        .code_out(code_out),
        .display(display)
    );

    initial begin
        $dumpfile("tb_top.vcd");
        $dumpvars(0, tb_top);

        data_in = 4'b0000; error_enable = 0; error_pos = 3'b000; #10;
        data_in = 4'b0001; error_enable = 0; error_pos = 3'b000; #10;
        data_in = 4'b1010; error_enable = 0; error_pos = 3'b000; #10;
        data_in = 4'b1010; error_enable = 1; error_pos = 3'b000; #10;
        data_in = 4'b1010; error_enable = 1; error_pos = 3'b011; #10;
        data_in = 4'b1111; error_enable = 1; error_pos = 3'b111; #10;

        $finish;
    end

    initial begin
        $monitor("t=%0t data_in=%b enable=%b pos=%b code_out=%b display=%b",
                 $time, data_in, error_enable, error_pos, code_out, display);
    end

endmodule