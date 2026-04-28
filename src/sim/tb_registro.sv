`timescale 1ns/1ps

module tb_registro;

    logic clk, reset, load;
    logic [3:0] digit;
    logic [11:0] number;

    registro_num uut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .digit(digit),
        .number(number)
    );

    always #5 clk = ~clk;

    task push(input [3:0] d);
    begin
        digit = d;
        load = 1;
        #10;
        load = 0;
        #10;
    end
    endtask

    initial begin
        $dumpfile("tb_registro.vcd");
        $dumpvars(0, tb_registro);

        clk = 0;
        reset = 1;
        load = 0;
        digit = 0;

        #10 reset = 0;

        // Simulación
        push(1);
        push(2);
        push(3);

        #50;

        $finish;
    end

endmodule