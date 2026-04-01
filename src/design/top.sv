module top (
    input  [3:0] data_in,
    output [7:0] display
);

    seven_seg_decoder dec (
        .data_in(data_in),
        .display(display)
    );

endmodule