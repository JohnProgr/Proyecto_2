`timescale 1ns/1ps

module divider_comb (
    input  logic [5:0] dividend_i,
    input  logic [3:0] divisor_i,

    output logic [5:0] quotient_o,
    output logic [3:0] remainder_o,
    output logic       div_zero_o
);

    // El residuo interno usa 5 bits.
    // Esto permite hacer shift y comparar/restar contra divisor extendido.
    logic [4:0] divisor_ext;

    logic [4:0] rem_shift_5;
    logic [4:0] rem_shift_4;
    logic [4:0] rem_shift_3;
    logic [4:0] rem_shift_2;
    logic [4:0] rem_shift_1;
    logic [4:0] rem_shift_0;

    logic [4:0] rem_next_5;
    logic [4:0] rem_next_4;
    logic [4:0] rem_next_3;
    logic [4:0] rem_next_2;
    logic [4:0] rem_next_1;
    logic [4:0] rem_next_0;

    logic [4:0] diff_5;
    logic [4:0] diff_4;
    logic [4:0] diff_3;
    logic [4:0] diff_2;
    logic [4:0] diff_1;
    logic [4:0] diff_0;

    logic q5;
    logic q4;
    logic q3;
    logic q2;
    logic q1;
    logic q0;

    logic cout_5;
    logic cout_4;
    logic cout_3;
    logic cout_2;
    logic cout_1;
    logic cout_0;

    assign div_zero_o = (divisor_i == 4'd0);

    assign divisor_ext = {1'b0, divisor_i};

    // Etapa para bit 5 del dividendo.
    assign rem_shift_5 = {4'b0000, dividend_i[5]};

    divider_stage #(
        .WIDTH(5)
    ) stage_5 (
        .r_i      (rem_shift_5),
        .b_i      (divisor_ext),
        .diff_o   (diff_5),
        .r_next_o (rem_next_5),
        .q_bit_o  (q5),
        .cout_o   (cout_5)
    );

    // Etapa para bit 4.
    assign rem_shift_4 = {rem_next_5[3:0], dividend_i[4]};

    divider_stage #(
        .WIDTH(5)
    ) stage_4 (
        .r_i      (rem_shift_4),
        .b_i      (divisor_ext),
        .diff_o   (diff_4),
        .r_next_o (rem_next_4),
        .q_bit_o  (q4),
        .cout_o   (cout_4)
    );

    // Etapa para bit 3.
    assign rem_shift_3 = {rem_next_4[3:0], dividend_i[3]};

    divider_stage #(
        .WIDTH(5)
    ) stage_3 (
        .r_i      (rem_shift_3),
        .b_i      (divisor_ext),
        .diff_o   (diff_3),
        .r_next_o (rem_next_3),
        .q_bit_o  (q3),
        .cout_o   (cout_3)
    );

    // Etapa para bit 2.
    assign rem_shift_2 = {rem_next_3[3:0], dividend_i[2]};

    divider_stage #(
        .WIDTH(5)
    ) stage_2 (
        .r_i      (rem_shift_2),
        .b_i      (divisor_ext),
        .diff_o   (diff_2),
        .r_next_o (rem_next_2),
        .q_bit_o  (q2),
        .cout_o   (cout_2)
    );

    // Etapa para bit 1.
    assign rem_shift_1 = {rem_next_2[3:0], dividend_i[1]};

    divider_stage #(
        .WIDTH(5)
    ) stage_1 (
        .r_i      (rem_shift_1),
        .b_i      (divisor_ext),
        .diff_o   (diff_1),
        .r_next_o (rem_next_1),
        .q_bit_o  (q1),
        .cout_o   (cout_1)
    );

    // Etapa para bit 0.
    assign rem_shift_0 = {rem_next_1[3:0], dividend_i[0]};

    divider_stage #(
        .WIDTH(5)
    ) stage_0 (
        .r_i      (rem_shift_0),
        .b_i      (divisor_ext),
        .diff_o   (diff_0),
        .r_next_o (rem_next_0),
        .q_bit_o  (q0),
        .cout_o   (cout_0)
    );

    always_comb begin
        if (div_zero_o) begin
            quotient_o  = 6'd0;
            remainder_o = 4'd0;
        end else begin
            quotient_o  = {q5, q4, q3, q2, q1, q0};
            remainder_o = rem_next_0[3:0];
        end
    end

endmodule