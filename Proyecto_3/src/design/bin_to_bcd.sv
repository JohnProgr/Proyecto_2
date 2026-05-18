`timescale 1ns/1ps

module bin_to_bcd (
    input  logic [5:0] bin_i,

    output logic [3:0] tens_o,
    output logic [3:0] ones_o
);

    assign tens_o = bin_i / 6'd10;
    assign ones_o = bin_i % 6'd10;

endmodule