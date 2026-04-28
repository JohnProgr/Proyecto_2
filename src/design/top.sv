module top (
    input  logic clk,
    input  logic reset,
    input  logic key_valid,
    input  logic [3:0] key_value,

    output logic [12:0] result
);

    // Señales internas
    logic load_num1, load_num2, do_sum, clear;
    logic [11:0] num1, num2;

    // FSM
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

    // Registro num1
    registro_num reg1 (
        .clk(clk),
        .reset(reset | clear),
        .load(load_num1),
        .digit(key_value),
        .number(num1)
    );

    // Registro num2
    registro_num reg2 (
        .clk(clk),
        .reset(reset | clear),
        .load(load_num2),
        .digit(key_value),
        .number(num2)
    );

    // Sumador
    sumador sum (
        .clk(clk),
        .reset(reset),
        .enable(do_sum),
        .num1(num1),
        .num2(num2),
        .result(result)
    );

endmodule