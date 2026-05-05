module debounce_sync (
    input  logic clk,
    input  logic rst,
    input  logic key,
    output logic key_pressed
);

    logic [15:0] count;
    logic key_sync_0, key_sync_1;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            key_sync_0 <= 0;
            key_sync_1 <= 0;
        end else begin
            key_sync_0 <= key;
            key_sync_1 <= key_sync_0;
        end
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            key_pressed <= 0;
        end else begin
            if (key_sync_1) begin
                if (count < 16'hFFFF)
                    count <= count + 1;
                else
                    key_pressed <= 1;
            end else begin
                count <= 0;
                key_pressed <= 0;
            end
        end
    end

endmodule