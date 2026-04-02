module syndrome_decoder (
    input  [7:0] code_in,
    output [2:0] syndrome,
    output       global_parity_error
);

    assign syndrome[0] = code_in[0] ^ code_in[2] ^ code_in[4] ^ code_in[6];
    assign syndrome[1] = code_in[1] ^ code_in[2] ^ code_in[5] ^ code_in[6];
    assign syndrome[2] = code_in[3] ^ code_in[4] ^ code_in[5] ^ code_in[6];

 wire parity_calc;

assign parity_calc = code_in[0] ^ code_in[1] ^ code_in[2] ^ code_in[3] ^
                     code_in[4] ^ code_in[5] ^ code_in[6];

assign global_parity_error = parity_calc ^ code_in[7];
endmodule