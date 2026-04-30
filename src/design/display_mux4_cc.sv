module display_mux4_cc (
    input  logic clk,
    input  logic rst_n,

    input  logic [13:0] value,

    output logic [6:0] seg,
    output logic [3:0] an
);

    localparam int REFRESH_MAX = 27000;

    logic [$clog2(REFRESH_MAX)-1:0] refresh_count;
    logic [1:0] digit_sel;

    logic [3:0] thousands;
    logic [3:0] hundreds;
    logic [3:0] tens;
    logic [3:0] ones;

    logic [3:0] current_digit;

    bin_to_bcd4 bcd_inst (
        .bin(value),
        .thousands(thousands),
        .hundreds(hundreds),
        .tens(tens),
        .ones(ones)
    );

    bcd_to_7seg_cc seg_decoder (
        .bcd(current_digit),
        .seg(seg)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            refresh_count <= 0;
            digit_sel <= 0;
        end
        else begin
            if (refresh_count == REFRESH_MAX - 1) begin
                refresh_count <= 0;
                digit_sel <= digit_sel + 1;
            end
            else begin
                refresh_count <= refresh_count + 1;
            end
        end
    end

    always_comb begin

        current_digit = 4'd0;
        an = 4'b1111;

        case (digit_sel)

            2'd0: begin
                current_digit = thousands;
                an = 4'b1110;
            end

            2'd1: begin
                current_digit = hundreds;
                an = 4'b1101;
            end

            2'd2: begin
                current_digit = tens;
                an = 4'b1011;
            end

            2'd3: begin
                current_digit = ones;
                an = 4'b0111;
            end

        endcase
    end

endmodule