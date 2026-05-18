`timescale 1ns/1ps

module system_top_direct (
    input  logic       clk,
    input  logic       rst_n,

    input  logic       valid_i,
    input  logic [5:0] dividend_i,
    input  logic [3:0] divisor_i,
    input  logic       select_i,

    output logic [6:0] seven,
    output logic [3:0] anodo,
    output logic       done_o,
    output logic       div_zero_o
);

    logic [5:0] quotient;
    logic [3:0] remainder;

    divider_core divider_inst (
        .clk         (clk),
        .rst_n       (rst_n),
        .valid_i     (valid_i),
        .dividend_i  (dividend_i),
        .divisor_i   (divisor_i),
        .quotient_o  (quotient),
        .remainder_o (remainder),
        .div_zero_o  (div_zero_o),
        .done_o      (done_o)
    );

    display_result_controller display_inst (
        .clk         (clk),
        .rst_n       (rst_n),
        .quotient_i  (quotient),
        .remainder_i (remainder),
        .select_i    (select_i),
        .seven       (seven),
        .anodo       (anodo)
    );

endmodule