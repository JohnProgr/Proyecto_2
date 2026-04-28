module display_mux #(
    parameter CLK_HZ = 27_000_000
)(
    input  logic        clk,
    input  logic        reset,
    input  logic [12:0] number,
    output logic [3:0]  an,
    output logic [6:0]  seg
);

localparam REFRESH_DIV = (CLK_HZ / 1000 < 2) ? 2 : CLK_HZ / 1000;
localparam DIV_BITS    = $clog2(REFRESH_DIV + 1);

logic [DIV_BITS-1:0] div_cnt;
logic                refresh_tick;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        div_cnt      <= 0;
        refresh_tick <= 0;
    end else if (div_cnt == REFRESH_DIV - 1) begin
        div_cnt      <= 0;
        refresh_tick <= 1;
    end else begin
        div_cnt      <= div_cnt + 1;
        refresh_tick <= 0;
    end
end

logic [1:0] disp_idx;

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        disp_idx <= 0;
    else if (refresh_tick)
        disp_idx <= disp_idx + 1;
end

// Conversion binario a BCD usando double dabble
logic [3:0] d0, d1, d2, d3;

always_comb begin
    logic [12:0] tmp;
    tmp = number;
    d3 = 0; d2 = 0; d1 = 0; d0 = 0;

    for (int i = 12; i >= 0; i--) begin
        if (d3 >= 5) d3 = d3 + 3;
        if (d2 >= 5) d2 = d2 + 3;
        if (d1 >= 5) d1 = d1 + 3;
        if (d0 >= 5) d0 = d0 + 3;

        d3 = {d3[2:0], d2[3]};
        d2 = {d2[2:0], d1[3]};
        d1 = {d1[2:0], d0[3]};
        d0 = {d0[2:0], tmp[i]};
    end
end

logic [3:0] active_digit;

always_comb begin
    case (disp_idx)
        2'd0: active_digit = d0;
        2'd1: active_digit = d1;
        2'd2: active_digit = d2;
        2'd3: active_digit = d3;
        default: active_digit = 4'd0;
    endcase
end

always_comb begin
    case (disp_idx)
        2'd0: an = 4'b1110;
        2'd1: an = 4'b1101;
        2'd2: an = 4'b1011;
        2'd3: an = 4'b0111;
        default: an = 4'b1111;
    endcase
end

bcd_to_7seg decoder (
    .digit(active_digit),
    .seg(seg)
);

endmodule