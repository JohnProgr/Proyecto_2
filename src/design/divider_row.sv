`timescale 1ns/1ps

module divider_row #(
    parameter int WIDTH = 4
)(
    input  logic [WIDTH-1:0] r_i,
    input  logic [WIDTH-1:0] b_i,
    input  logic             accept_i,

    output logic [WIDTH-1:0] diff_o,
    output logic [WIDTH-1:0] r_next_o,
    output logic             cout_o
);

    logic [WIDTH:0] carry;

    assign carry[0] = 1'b1; // Suma el +1 del complemento a 2

    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin : gen_cells
            divider_cell cell_inst (
                .r_i      (r_i[i]),
                .b_i      (b_i[i]),
                .cin_i    (carry[i]),
                .accept_i (accept_i),
                .diff_o   (diff_o[i]),
                .cout_o   (carry[i+1]),
                .r_next_o (r_next_o[i])
            );
        end
    endgenerate

    assign cout_o = carry[WIDTH];

endmodule