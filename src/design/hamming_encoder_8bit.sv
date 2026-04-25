module hamming_encoder_8bit (
    input  logic [3:0] data_in,   // {d4,d3,d2,d1}
    output logic [7:0] code_out   // {p0,p1,p2,d1,p3,d2,d3,d4}
);

    logic d1, d2, d3, d4;
    logic p0, p1, p2, p3;

    always_comb begin
        d4 = data_in[3];
        d3 = data_in[2];
        d2 = data_in[1];
        d1 = data_in[0];

        p1 = d1 ^ d2 ^ d4;
        p2 = d1 ^ d3 ^ d4;
        p3 = d2 ^ d3 ^ d4;
        p0 = p1 ^ p2 ^ d1 ^ p3 ^ d2 ^ d3 ^ d4;

        code_out = {p0, p1, p2, d1, p3, d2, d3, d4};
    end

endmodule