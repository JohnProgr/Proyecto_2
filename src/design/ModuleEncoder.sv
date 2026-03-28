module hamming_encoder_8bit (
    input  [3:0] data_in,   // {d4,d3,d2,d1}
    output [7:0] code_out   // {p0,p1,p2,d1,p3,d2,d3,d4}
);

    wire d1, d2, d3, d4;
    wire p0, p1, p2, p3;

    assign d4 = data_in[3];
    assign d3 = data_in[2];
    assign d2 = data_in[1];
    assign d1 = data_in[0];

    assign p1 = d1 ^ d2 ^ d4;
    assign p2 = d1 ^ d3 ^ d4;
    assign p3 = d2 ^ d3 ^ d4;

    assign p0 = p1 ^ p2 ^ d1 ^ p3 ^ d2 ^ d3 ^ d4;

    assign code_out = {p0, p1, p2, d1, p3, d2, d3, d4};

endmodule