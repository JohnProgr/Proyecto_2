module key_edge_detect #(
    parameter int SCAN_HZ = 2000
)(
    input  logic clk,
    input  logic rst,
    input  logic key_in,
    output logic key_valid
);

    debounce u_debounce (
        .clk(clk),
        .rst(rst),
        .key(key_in),
        .key_pressed(key_valid)
    );

endmodule