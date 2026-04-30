module sync_2ff #(
    parameter int WIDTH = 1
)(
    input  logic clk,
    input  logic rst_n,
    input  logic [WIDTH-1:0] async_in,
    output logic [WIDTH-1:0] sync_out
);

    logic [WIDTH-1:0] ff1;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ff1      <= '0;
            sync_out <= '0;
        end else begin
            ff1      <= async_in;
            sync_out <= ff1;
        end
    end

endmodule