module error_corrector (
    input  [7:0] code_in,
    input  [2:0] syndrome,
    input        global_parity_error,
    output [7:0] corrected_code,
    output [3:0] data_out,
    output       single_error,
    output       double_error,
    output       parity_bit_error
);

    wire [7:0] error_mask;

    assign error_mask[0] = (syndrome == 3'b001) ? 1'b1 : 1'b0;
    assign error_mask[1] = (syndrome == 3'b010) ? 1'b1 : 1'b0;
    assign error_mask[2] = (syndrome == 3'b011) ? 1'b1 : 1'b0;
    assign error_mask[3] = (syndrome == 3'b100) ? 1'b1 : 1'b0;
    assign error_mask[4] = (syndrome == 3'b101) ? 1'b1 : 1'b0;
    assign error_mask[5] = (syndrome == 3'b110) ? 1'b1 : 1'b0;
    assign error_mask[6] = (syndrome == 3'b111) ? 1'b1 : 1'b0;
    assign error_mask[7] = 1'b0;

    assign single_error    = (syndrome != 3'b000) && (global_parity_error == 1'b1);
    assign parity_bit_error = (syndrome == 3'b000) && (global_parity_error == 1'b1);
    assign double_error    = (syndrome != 3'b000) && (global_parity_error == 1'b0);

    assign corrected_code = single_error ? (code_in ^ error_mask) : code_in;

    assign data_out[0] = corrected_code[2];
    assign data_out[1] = corrected_code[4];
    assign data_out[2] = corrected_code[5];
    assign data_out[3] = corrected_code[6];

endmodule