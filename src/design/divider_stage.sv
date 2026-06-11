`timescale 1ns/1ps

module divider_stage #(
    parameter int WIDTH = 4
)(
    input  logic [WIDTH-1:0] r_i,
    input  logic [WIDTH-1:0] b_i,

    output logic [WIDTH-1:0] diff_o,
    output logic [WIDTH-1:0] r_next_o,
    output logic             q_bit_o,
    output logic             cout_o
);

    logic [WIDTH-1:0] row_diff;
    logic [WIDTH-1:0] row_r_next;
    logic             row_cout;

    // Primero se intenta hacer la resta aceptando el resultado.
    divider_row #(
        .WIDTH(WIDTH)
    ) row_inst (
        .r_i      (r_i),
        .b_i      (b_i),
        .accept_i (1'b1),
        .diff_o   (row_diff),
        .r_next_o (row_r_next),
        .cout_o   (row_cout)
    );

    assign diff_o = row_diff;
    assign cout_o = row_cout;

    // Si cout_o = 1, la resta fue válida y se acepta diff.
    // Si cout_o = 0, la resta no alcanzó y se conserva r_i.
    assign r_next_o = (row_cout) ? row_diff : r_i;

    // El bit del cociente de esta etapa indica si la resta se aceptó.
    assign q_bit_o = row_cout;

endmodule