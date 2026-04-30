module top (
    input  logic clk,
    input  logic rst_n,

    input  logic [3:0] rows,
    output logic [3:0] cols,

    output logic [6:0] seg,
    output logic [3:0] an
);

    logic [13:0] display_value;

    assign display_value = 14'd1234;
    assign cols = 4'b0000;

    display_mux4_cc display_inst (
        .clk(clk),
        .rst_n(rst_n),
        .value(display_value),
        .seg(seg),
        .an(an)
    );

endmodule