`timescale 1ns/1ps

module display_result_controller (
    input  logic       clk,
    input  logic       rst_n,

    input  logic [5:0] quotient_i,
    input  logic [3:0] remainder_i,
    input  logic       select_i,

    output logic [6:0] seven,
    output logic [3:0] anodo
);

    logic [5:0] selected_result;
    logic [3:0] tens;
    logic [3:0] ones;

    result_selector selector_inst (
        .quotient_i        (quotient_i),
        .remainder_i       (remainder_i),
        .select_i          (select_i),
        .selected_result_o (selected_result)
    );

    bin_to_bcd bcd_inst (
        .bin_i  (selected_result),
        .tens_o (tens),
        .ones_o (ones)
    );

    display_mux4 mux_inst (
        .clk   (clk),
        .rst_n (rst_n),
        .d3    (4'd0),
        .d2    (4'd0),
        .d1    (tens),
        .d0    (ones),
        .seven (seven),
        .anodo (anodo)
    );

endmodule