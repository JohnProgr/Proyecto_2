`timescale 1ns/1ps

module tb_top;

logic       clk, reset;
logic [3:0] rows;
logic [3:0] cols;
logic [3:0] an;
logic [6:0] seg;

top #(.CLK_HZ(20)) uut (
    .clk(clk),
    .reset(reset),
    .rows(rows),
    .cols(cols),
    .an(an),
    .seg(seg)
);

always #5 clk = ~clk;

task press_key(input [3:0] row_active);
begin
    rows = row_active;
    #2000;
    rows = 4'b1111;
    #500;
end
endtask

initial begin
    $dumpfile("tb_top_system.vcd");
    $dumpvars(0, tb_top);

    clk = 0; reset = 1; rows = 4'b1111;
    #20 reset = 0;
    #500;

    // NUM1: tecla 1 (fila 0)
    press_key(4'b1110);
    // NUM1: tecla 2 (fila 0)
    press_key(4'b1110);
    // NUM1: tecla 3 (fila 0)
    press_key(4'b1110);
    // Confirmar # (fila 3)
    press_key(4'b0111);

    // NUM2: tecla 4 (fila 1)
    press_key(4'b1101);
    // NUM2: tecla 5 (fila 1)
    press_key(4'b1101);
    // Confirmar # (fila 3)
    press_key(4'b0111);

    #5000;
    $finish;
end

endmodule