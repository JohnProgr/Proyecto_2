module keypad_scanner (
    input  logic clk,
    input  logic rst_n,

    input  logic [3:0] rows,
    output logic [3:0] cols,

    output logic key_valid,
    output logic [3:0] key_code
);

    localparam int SCAN_MAX = 27000;

    logic [3:0] rows_sync;
    logic [3:0] rows_clean;

    logic [$clog2(SCAN_MAX)-1:0] scan_count;
    logic [1:0] col_index;

    logic key_pressed;
    logic key_pressed_d;
    logic [3:0] decoded_key;

    sync_2ff #(
        .WIDTH(4)
    ) sync_rows (
        .clk(clk),
        .rst_n(rst_n),
        .async_in(rows),
        .sync_out(rows_sync)
    );

    debounce #(
        .WIDTH(4),
        .COUNT_MAX(270000)
    ) debounce_rows (
        .clk(clk),
        .rst_n(rst_n),
        .noisy(rows_sync),
        .clean(rows_clean)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scan_count <= '0;
            col_index  <= 2'd0;
        end else begin
            if (scan_count == SCAN_MAX - 1) begin
                scan_count <= '0;
                col_index  <= col_index + 1;
            end else begin
                scan_count <= scan_count + 1;
            end
        end
    end

    always_comb begin
        cols = 4'b0000;

        case (col_index)
            2'd0: cols = 4'b0001;
            2'd1: cols = 4'b0010;
            2'd2: cols = 4'b0100;
            2'd3: cols = 4'b1000;
            default: cols = 4'b0001;
        endcase
    end

    always_comb begin
        key_pressed = |rows_clean;
        decoded_key = 4'hF;

        case ({rows_clean, col_index})
            {4'b0001, 2'd0}: decoded_key = 4'h1;
            {4'b0001, 2'd1}: decoded_key = 4'h2;
            {4'b0001, 2'd2}: decoded_key = 4'h3;
            {4'b0001, 2'd3}: decoded_key = 4'hA;

            {4'b0010, 2'd0}: decoded_key = 4'h4;
            {4'b0010, 2'd1}: decoded_key = 4'h5;
            {4'b0010, 2'd2}: decoded_key = 4'h6;
            {4'b0010, 2'd3}: decoded_key = 4'hB;

            {4'b0100, 2'd0}: decoded_key = 4'h7;
            {4'b0100, 2'd1}: decoded_key = 4'h8;
            {4'b0100, 2'd2}: decoded_key = 4'h9;
            {4'b0100, 2'd3}: decoded_key = 4'hC;

            {4'b1000, 2'd0}: decoded_key = 4'hE; // *
            {4'b1000, 2'd1}: decoded_key = 4'h0;
            {4'b1000, 2'd2}: decoded_key = 4'hF; // #
            {4'b1000, 2'd3}: decoded_key = 4'hD;

            default: decoded_key = 4'hF;
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            key_pressed_d <= 1'b0;
            key_valid     <= 1'b0;
            key_code      <= 4'd0;
        end else begin
            key_pressed_d <= key_pressed;
            key_valid     <= 1'b0;

            if (key_pressed && !key_pressed_d) begin
                key_valid <= 1'b1;
                key_code  <= decoded_key;
            end
        end
    end

endmodule