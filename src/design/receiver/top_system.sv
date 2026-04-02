module top_system (
    input  [3:0] data_in,
    input        error_enable,
    input  [2:0] error_pos,

    output [7:0] tx_code,
    output [7:0] corrected_code,
    output [3:0] data_out,
    output [2:0] syndrome,
    output       global_parity_error,
    output       single_error,
    output       double_error,
    output       parity_bit_error,
    output [7:0] seg_tx,
    output [7:0] seg_rx
);

    wire [7:0] encoded_code;
    wire [7:0] channel_code;

    // Transmisor
    hamming_encoder u_hamming_encoder (
        .data_in(data_in),
        .code_out(encoded_code)
    );

    error_generator_8bit u_error_generator (
        .code_in(encoded_code),
        .error_enable(error_enable),
        .error_pos(error_pos),
        .code_out(channel_code)
    );

    seven_seg_decoder u_seven_seg_tx (
        .data_in(data_in),
        .display(seg_tx)
    );

    // Receptor
    top_receiver u_top_receiver (
        .code_in(channel_code),
        .syndrome(syndrome),
        .global_parity_error(global_parity_error),
        .corrected_code(corrected_code),
        .data_out(data_out),
        .single_error(single_error),
        .double_error(double_error),
        .parity_bit_error(parity_bit_error),
        .seg(seg_rx)
    );

    assign tx_code = channel_code;

endmodule