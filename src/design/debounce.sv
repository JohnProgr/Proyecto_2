module debounce #(
    parameter CLK_HZ      = 27_000_000,
    parameter DEBOUNCE_MS = 20
)(
    input  logic clk,
    input  logic reset,
    input  logic noisy_in,
    output logic clean_out
);

localparam COUNT_MAX = (CLK_HZ / 1000 * DEBOUNCE_MS < 2) ? 2 : CLK_HZ / 1000 * DEBOUNCE_MS;
localparam CNT_BITS  = $clog2(COUNT_MAX + 1);

logic [CNT_BITS-1:0] counter;
logic sync_reg;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        counter   <= 0;
        sync_reg  <= 0;
        clean_out <= 0;
    end else begin
        if (noisy_in == sync_reg) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == COUNT_MAX - 1) begin
                sync_reg  <= noisy_in;
                clean_out <= noisy_in;
                counter   <= 0;
            end
        end
    end
end

endmodule