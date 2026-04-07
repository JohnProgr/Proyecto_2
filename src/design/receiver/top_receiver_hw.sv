module top_receiver_hw (
    input  [7:0] code_in,
    input        selector_sw,
    output [3:0] led,
    output [7:0] seg,
    output       led_double_error
);

    wire [2:0] syndrome;
    wire       global_parity_error;
    wire [7:0] corrected_code;
    wire [3:0] data_out;
    wire       single_error;
    wire       double_error;
    wire       parity_bit_error;
    wire [3:0] display_data;

    top_receiver u_top_receiver (
        .code_in(code_in),
        .syndrome(syndrome),
        .global_parity_error(global_parity_error),
        .corrected_code(corrected_code),
        .data_out(data_out),
        .single_error(single_error),
        .double_error(double_error),
        .parity_bit_error(parity_bit_error)
    );

    assign led = ~data_out;
    assign led_double_error = double_error;
    assign display_data = selector_sw ? {1'b0, syndrome} : data_out;

    seven_seg_decoder u_seven_seg_decoder (
        .data_in(display_data),
        .display(seg)
    );

endmodule