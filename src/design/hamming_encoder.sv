module hamming_encoder (
    input  logic [7:0] data_in,
    output logic [12:0] code_out
);

    logic p1, p2, p4, p8, p_global;

    always_comb begin
        // Posiciones (1-indexed):
        // 1:p1, 2:p2, 3:d0, 4:p4, 5:d1, 6:d2, 7:d3,
        // 8:p8, 9:d4, 10:d5, 11:d6, 12:d7, 13:p_global

        code_out[2]  = data_in[0];
        code_out[4]  = data_in[1];
        code_out[5]  = data_in[2];
        code_out[6]  = data_in[3];
        code_out[8]  = data_in[4];
        code_out[9]  = data_in[5];
        code_out[10] = data_in[6];
        code_out[11] = data_in[7];

        // Paridades Hamming
        p1 = code_out[2] ^ code_out[4] ^ code_out[6] ^ code_out[8] ^ code_out[10];
        p2 = code_out[2] ^ code_out[5] ^ code_out[6] ^ code_out[9] ^ code_out[10];
        p4 = code_out[4] ^ code_out[5] ^ code_out[6] ^ code_out[11];
        p8 = code_out[8] ^ code_out[9] ^ code_out[10] ^ code_out[11];

        code_out[0] = p1;
        code_out[1] = p2;
        code_out[3] = p4;
        code_out[7] = p8;

        // Paridad global (para detectar doble error)
        p_global = ^code_out[11:0];
        code_out[12] = p_global;
    end

endmodule