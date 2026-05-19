`timescale 1ns/1ps

module system_top_keytest #(
    parameter integer KEYPAD_SCAN_DELAY    = 27000,
    parameter integer KEYPAD_RELEASE_DELAY = 200000
)(
    input  logic       clk,
    input  logic       rst_n,

    output logic [3:0] filas,
    input  logic [3:0] columnas,

    output logic [6:0] seven,
    output logic [3:0] anodo
);

    logic [3:0] key_value;
    logic       key_valid;
    logic [3:0] last_key;

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

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            last_key <= 4'h0;
        end else begin
            if (key_valid) begin
                last_key <= key_value;
            end
        end
    end

    display_mux4 display_inst (
        .clk   (clk),
        .rst_n (rst_n),
        .d3    (4'h0),
        .d2    (4'h0),
        .d1    (4'h0),
        .d0    (last_key),
        .seven (seven),
        .anodo (anodo)
    );

endmodule