module top (
    input  [3:0] data_in,
    output [7:0] code_out
);

    seven_seg_decoder dec (
        .data_in(data_in),
        .code_out(code_out)
    );

endmodule