`timescale 1ns/1ps

module tb_sumador;

    logic clk, reset, enable;
    logic [11:0] num1, num2;
    logic [12:0] result;

    sumador uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .num1(num1),
        .num2(num2),
        .result(result)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_sumador.vcd");
        $dumpvars(0, tb_sumador);

        clk = 0;
        reset = 1;
        enable = 0;
        num1 = 0;
        num2 = 0;

        #10 reset = 0;

        // Caso de prueba
        num1 = 123;
        num2 = 45;

        #10;
        enable = 1;   // activar suma
        #10;
        enable = 0;

        #50;

        $finish;
    end

endmodule