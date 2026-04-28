`timescale 1ns/1ps

module tb_top;

    logic clk, reset;
    logic key_valid;
    logic [3:0] key_value;
    logic [12:0] result;

    top uut (
        .clk(clk),
        .reset(reset),
        .key_valid(key_valid),
        .key_value(key_value),
        .result(result)
    );

    always #5 clk = ~clk;

    task press_key(input [3:0] key);
    begin
        key_value = key;
        key_valid = 1;
        #10;
        key_valid = 0;
        #20;
    end
    endtask

    initial begin
        $dumpfile("tb_top_system.vcd");
        $dumpvars(0, tb_top);

        clk = 0;
        reset = 1;
        key_valid = 0;
        key_value = 0;

        #20 reset = 0;

        // NUM1 = 123
        press_key(4'd1);
        press_key(4'd2);
        press_key(4'd3);

        // Confirmar
        press_key(4'hA);

        // NUM2 = 45
        press_key(4'd4);
        press_key(4'd5);

        // Confirmar
        press_key(4'hA);

        #50;

        // Nueva operación
        press_key(4'd7);

        #100;

        $finish;
    end

endmodule