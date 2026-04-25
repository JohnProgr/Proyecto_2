module top_receiver (
    input  [7:0] code_in,
    output [2:0] syndrome,
    output       global_parity_error,
    output [7:0] corrected_code,
    output [3:0] data_out,
    output       single_error,
    output       double_error,
    output       parity_bit_error
);

    wire [2:0] syndrome_wire;
    wire       global_parity_error_wire;
    wire [7:0] corrected_code_wire;
    wire [3:0] data_out_wire;
    wire       single_error_wire;
    wire       double_error_wire;
    wire       parity_bit_error_wire;

    syndrome_decoder u_syndrome_decoder (
        .code_in(code_in),
        .syndrome(syndrome_wire),
        .global_parity_error(global_parity_error_wire)
    );

    error_corrector u_error_corrector (
        .code_in(code_in),
        .syndrome(syndrome_wire),
        .global_parity_error(global_parity_error_wire),
        .corrected_code(corrected_code_wire),
        .data_out(data_out_wire),
        .single_error(single_error_wire),
        .double_error(double_error_wire),
        .parity_bit_error(parity_bit_error_wire)
    );

    assign syndrome            = syndrome_wire;
    assign global_parity_error = global_parity_error_wire;
    assign corrected_code      = corrected_code_wire;
    assign data_out            = data_out_wire;
    assign single_error        = single_error_wire;
    assign double_error        = double_error_wire;
    assign parity_bit_error    = parity_bit_error_wire;

endmodule