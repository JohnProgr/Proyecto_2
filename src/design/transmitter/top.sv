module top (
    input  [3:0] data_in,
    input  [2:0] error_pos1,
    input  [2:0] error_pos2,
    input  [1:0] num_errors,
    output [7:0] code_out,
    output [7:0] display
);

    wire [7:0] encoded_data;
    wire [7:0] error_data;

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
        .error_pos1(error_pos1),
        .error_pos2(error_pos2),
        .num_errors(num_errors),
        .code_out(error_data)
    );

   assign code_out = error_data;

endmodule