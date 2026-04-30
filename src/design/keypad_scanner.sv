module keypad_scanner (
    input  logic clk,
    input  logic rst_n,

    input  logic [3:0] rows,
    output logic [3:0] cols,

    output logic key_valid,
    output logic [3:0] key_code
);

    localparam int SCAN_MAX = 27000;

    typedef enum logic [1:0] {
        S_SCAN,
        S_WAIT_RELEASE
    } state_t;

    state_t state;

    logic [3:0] rows_sync;
    logic [$clog2(SCAN_MAX)-1:0] scan_count;
    logic [1:0] col_index;

    logic [3:0] decoded_key;
    logic match_valid;

    sync_2ff #(
        .WIDTH(4)
    ) sync_rows (
        .clk(clk),
        .rst_n(rst_n),
        .async_in(rows),
        .sync_out(rows_sync)
    );

    always_comb begin
        case (col_index)
            2'd0: cols = 4'b0111;
            2'd1: cols = 4'b1011;
            2'd2: cols = 4'b1101;
            2'd3: cols = 4'b1110;
            default: cols = 4'b1111;
        endcase

        if (state == S_WAIT_RELEASE)
            cols = 4'b0000;
    end

    always_comb begin
        decoded_key = 4'd0;
        match_valid = 1'b0;

        case ({rows_sync, col_index})

            {4'b0111, 2'd0}: begin decoded_key = 4'h1; match_valid = 1'b1; end
            {4'b0111, 2'd1}: begin decoded_key = 4'h2; match_valid = 1'b1; end
            {4'b0111, 2'd2}: begin decoded_key = 4'h3; match_valid = 1'b1; end
            {4'b0111, 2'd3}: begin decoded_key = 4'hA; match_valid = 1'b1; end

            {4'b1011, 2'd0}: begin decoded_key = 4'h4; match_valid = 1'b1; end
            {4'b1011, 2'd1}: begin decoded_key = 4'h5; match_valid = 1'b1; end
            {4'b1011, 2'd2}: begin decoded_key = 4'h6; match_valid = 1'b1; end
            {4'b1011, 2'd3}: begin decoded_key = 4'hB; match_valid = 1'b1; end

            {4'b1101, 2'd0}: begin decoded_key = 4'h7; match_valid = 1'b1; end
            {4'b1101, 2'd1}: begin decoded_key = 4'h8; match_valid = 1'b1; end
            {4'b1101, 2'd2}: begin decoded_key = 4'h9; match_valid = 1'b1; end
            {4'b1101, 2'd3}: begin decoded_key = 4'hC; match_valid = 1'b1; end

            {4'b1110, 2'd0}: begin decoded_key = 4'hE; match_valid = 1'b1; end
            {4'b1110, 2'd1}: begin decoded_key = 4'h0; match_valid = 1'b1; end
            {4'b1110, 2'd2}: begin decoded_key = 4'hF; match_valid = 1'b1; end
            {4'b1110, 2'd3}: begin decoded_key = 4'hD; match_valid = 1'b1; end

            default: begin
                decoded_key = 4'd0;
                match_valid = 1'b0;
            end

        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_SCAN;
            scan_count <= '0;
            col_index <= 2'd0;
            key_valid <= 1'b0;
            key_code <= 4'd0;
        end else begin
            key_valid <= 1'b0;

            case (state)

                S_SCAN: begin
                    if (scan_count == SCAN_MAX - 1) begin
                        scan_count <= '0;

                        if (match_valid) begin
                            key_valid <= 1'b1;
                            key_code <= decoded_key;
                            state <= S_WAIT_RELEASE;
                        end else begin
                            col_index <= col_index + 1;
                        end
                    end else begin
                        scan_count <= scan_count + 1;
                    end
                end

                S_WAIT_RELEASE: begin
                    if (rows_sync == 4'b1111) begin
                        state <= S_SCAN;
                        scan_count <= '0;
                    end
                end

            endcase
        end
    end

endmodule