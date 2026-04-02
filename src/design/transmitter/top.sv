module top (
    input  [3:0] data_in,
    input  [2:0] error_pos,
    input        error_enable,
    output [7:0] code_out,
    output [7:0] display
);

    wire [7:0] encoded_data;

    seven_seg_decoder dec (
        .data_in(data_in),
        .display(display)
    );

    hamming_encoder enc (
        .data_in(data_in),
        .code_out(encoded_data)
    );

    error_generator_8bit err (
        .code_in(encoded_data),
        .error_pos(error_pos),
        .error_enable(error_enable),
        .code_out(code_out)
    );

endmodule