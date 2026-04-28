`timescale 1ns/1ps

module tb_keyboard;

logic       clk, reset;
logic [3:0] rows;
logic [3:0] cols;
logic       key_valid;
logic [3:0] key_value;

// CLK_HZ=10 para que el scan_tick ocurra cada 10 ciclos
keyboard_scanner #(.CLK_HZ(10)) uut (
    .clk(clk),
    .reset(reset),
    .rows(rows),
    .cols(cols),
    .key_valid(key_valid),
    .key_value(key_value)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("tb_keyboard.vcd");
    $dumpvars(0, tb_keyboard);

    clk = 0; reset = 1; rows = 4'b1111;
    #20 reset = 0;

    // Esperar varios ciclos de barrido
    #200;

    // Simular tecla "5": fila 1 activa (rows[1]=0)
    // col_idx estará en 1 en algún momento del barrido
    rows = 4'b1101;
    #200;
    rows = 4'b1111;
    #100;

    // Simular tecla "1": fila 0 activa
    rows = 4'b1110;
    #200;
    rows = 4'b1111;
    #100;

    // Simular tecla "#" (confirmacion): fila 3, columna 2
    rows = 4'b0111;
    #200;
    rows = 4'b1111;
    #100;

    $finish;
end

endmodule