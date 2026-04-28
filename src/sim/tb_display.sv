`timescale 1ns/1ps

module tb_display;

logic        clk, reset;
logic [12:0] number;
logic [3:0]  an;
logic [6:0]  seg;

display_mux #(.CLK_HZ(1)) uut (
    .clk(clk),
    .reset(reset),
    .number(number),
    .an(an),
    .seg(seg)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("tb_display.vcd");
    $dumpvars(0, tb_display);
    clk = 0;
    reset = 1;
    number = 0;
end

initial begin
    #20 reset = 0;
    number = 13'd168;
    #5000;
    number = 13'd1998;
    #5000;
    $finish;
end

endmodule