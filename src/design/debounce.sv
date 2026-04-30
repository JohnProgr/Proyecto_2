module debounce #(
    parameter int WIDTH = 4,
    parameter int COUNT_MAX = 270000
)(
    input  logic clk,
    input  logic rst_n,
    input  logic [WIDTH-1:0] noisy,
    output logic [WIDTH-1:0] clean
);

    logic [WIDTH-1:0] last;
    logic [$clog2(COUNT_MAX)-1:0] count;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clean <= '0;
            last  <= '0;
            count <= '0;
        end else begin
            if (noisy != last) begin
                last  <= noisy;
                count <= '0;
            end else begin
                if (count == COUNT_MAX - 1) begin
                    clean <= last;
                end else begin
                    count <= count + 1;
                end
            end
        end
    end

endmodule