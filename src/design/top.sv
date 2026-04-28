module top #(
    parameter CLK_HZ = 27_000_000
)(
    input  logic       clk,
    input  logic       reset,
    input  logic [3:0] rows,
    output logic [3:0] cols,
    output logic [3:0] an,
    output logic [6:0] seg
);

    logic [3:0] rows_sync;
    logic [3:0] rows_clean;
    logic       key_valid;
    logic [3:0] key_value;
    logic       load_num1, load_num2, do_sum, clear;
    logic [11:0] num1, num2;
    logic [12:0] result;

    sincronizador sync0 (.clk(clk), .async_in(rows[0]), .sync_out(rows_sync[0]));
    sincronizador sync1 (.clk(clk), .async_in(rows[1]), .sync_out(rows_sync[1]));
    sincronizador sync2 (.clk(clk), .async_in(rows[2]), .sync_out(rows_sync[2]));
    sincronizador sync3 (.clk(clk), .async_in(rows[3]), .sync_out(rows_sync[3]));

    debounce #(.CLK_HZ(CLK_HZ)) deb0 (.clk(clk), .reset(reset), .noisy_in(rows_sync[0]), .clean_out(rows_clean[0]));
    debounce #(.CLK_HZ(CLK_HZ)) deb1 (.clk(clk), .reset(reset), .noisy_in(rows_sync[1]), .clean_out(rows_clean[1]));
    debounce #(.CLK_HZ(CLK_HZ)) deb2 (.clk(clk), .reset(reset), .noisy_in(rows_sync[2]), .clean_out(rows_clean[2]));
    debounce #(.CLK_HZ(CLK_HZ)) deb3 (.clk(clk), .reset(reset), .noisy_in(rows_sync[3]), .clean_out(rows_clean[3]));

    keyboard_scanner #(.CLK_HZ(CLK_HZ)) kb (
        .clk(clk),
        .reset(reset),
        .rows(rows_clean),
        .cols(cols),
        .key_valid(key_valid),
        .key_value(key_value)
    );

    fsm_control fsm (
        .clk(clk),
        .reset(reset),
        .key_valid(key_valid),
        .key_value(key_value),
        .load_num1(load_num1),
        .load_num2(load_num2),
        .do_sum(do_sum),
        .clear(clear)
    );

    registro_num reg1 (
        .clk(clk),
        .reset(reset | clear),
        .load(load_num1),
        .digit(key_value),
        .number(num1)
    );

    registro_num reg2 (
        .clk(clk),
        .reset(reset | clear),
        .load(load_num2),
        .digit(key_value),
        .number(num2)
    );

    sumador sum (
        .clk(clk),
        .reset(reset),
        .enable(do_sum),
        .num1(num1),
        .num2(num2),
        .result(result)
    );

    display_mux #(.CLK_HZ(CLK_HZ)) disp (
        .clk(clk),
        .reset(reset),
        .number(result),
        .an(an),
        .seg(seg)
    );

endmodule