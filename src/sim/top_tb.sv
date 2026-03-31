`timescale 1ns/1ps

module top_tb;

wire [5:0] led;

top uut (
    .led(led)
);

initial begin
    $dumpfile("top_tb.vcd");
    $dumpvars(0, top_tb);

    #10;
    $finish;
end

endmodule