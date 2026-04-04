module top_receiver_hw (
    input  [7:0] code_in,
    output [3:0] led,
    output [7:0] seg,
    output [2:0] syndrome,
    output       global_parity_error,
    output       single_error,
    output       double_error,
    output       parity_bit_error
);

    wire [7:0] corrected_code;
    wire [3:0] data_out;

    top_receiver u_top_receiver (
        .code_in(code_in),
        .syndrome(syndrome),
        .global_parity_error(global_parity_error),
        .corrected_code(corrected_code),
        .data_out(data_out),
        .single_error(single_error),
        .double_error(double_error),
        .parity_bit_error(parity_bit_error),
        .seg(seg)
    );

    assign led = data_out;

endmodule