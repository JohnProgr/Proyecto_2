module top (
    input  logic clk,
    input  logic rst_n,

    input  logic [3:0] rows,
    output logic [3:0] cols,

    output logic [6:0] seg,
    output logic [3:0] an
);

    logic key_valid;
    logic [3:0] key_code;

    logic [13:0] display_value;

    keypad_scanner keypad_inst (
        .clk(clk),
        .rst_n(rst_n),
        .rows(rows),
        .cols(cols),
        .key_valid(key_valid),
        .key_code(key_code)
    );

    input_fsm fsm_inst (
        .clk(clk),
        .rst_n(rst_n),
        .key_valid(key_valid),
        .key_code(key_code),
        .display_value(display_value)
    );

    display_mux4_cc display_inst (
        .clk(clk),
        .rst_n(rst_n),
        .value(display_value),
        .seg(seg),
        .an(an)
    );

endmodule