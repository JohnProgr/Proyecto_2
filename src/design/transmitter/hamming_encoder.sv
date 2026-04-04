module hamming_encoder (
    input  [3:0] data_in,
    output [7:0] code_out
);

    wire p1, p2, p4, p_global;

    assign code_out[2] = data_in[0];
    assign code_out[4] = data_in[1];
    assign code_out[5] = data_in[2];
    assign code_out[6] = data_in[3];

    assign p1 = data_in[0] ^ data_in[1] ^ data_in[3];
    assign p2 = data_in[0] ^ data_in[2] ^ data_in[3];
    assign p4 = data_in[1] ^ data_in[2] ^ data_in[3];

    assign code_out[0] = p1;
    assign code_out[1] = p2;
    assign code_out[3] = p4;

    assign code_out[7] = code_out[0] ^ code_out[1] ^ code_out[2] ^
                         code_out[3] ^ code_out[4] ^ code_out[5] ^
                         code_out[6];

endmodule