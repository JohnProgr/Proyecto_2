`timescale 1ns/1ps

module system_top #(
    parameter integer KEYPAD_SCAN_DELAY    = 27000,
    parameter integer KEYPAD_RELEASE_DELAY = 200000
)(
    input  logic       clk,
    input  logic       rst_n,

    // Teclado 4x4
    output logic [3:0] filas,
    input  logic [3:0] columnas,

    // Selector: 0 = cociente, 1 = residuo
    input  logic       select_i,

    // Display 7 segmentos
    output logic [6:0] seven,
    output logic [3:0] anodo,

    // Estado
    output logic       done_o,
    output logic       div_zero_o
);

    logic [3:0] key_value;
    logic       key_valid;

    logic [5:0] dividend;
    logic [3:0] divisor;
    logic       input_valid;

    logic [5:0] quotient;
    logic [3:0] remainder;

    keypad_reader #(
        .SCAN_DELAY(KEYPAD_SCAN_DELAY),
        .RELEASE_DELAY(KEYPAD_RELEASE_DELAY)
    ) keypad_inst (
        .clk       (clk),
        .rst_n     (rst_n),
        .filas     (filas),
        .columnas  (columnas),
        .key_value (key_value),
        .key_valid (key_valid)
    );

    input_controller input_inst (
        .clk         (clk),
        .rst_n       (rst_n),
        .key_value_i (key_value),
        .key_valid_i (key_valid),
        .dividend_o  (dividend),
        .divisor_o   (divisor),
        .valid_o     (input_valid)
    );

    divider_core divider_inst (
        .clk         (clk),
        .rst_n       (rst_n),
        .valid_i     (input_valid),
        .dividend_i  (dividend),
        .divisor_i   (divisor),
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