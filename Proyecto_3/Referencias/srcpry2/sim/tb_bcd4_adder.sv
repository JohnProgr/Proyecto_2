`timescale 1ns/1ps

module tb_bcd4_adder;

    logic [3:0] a3, a2, a1, a0;
    logic [3:0] b3, b2, b1, b0;
    logic [3:0] r3, r2, r1, r0;
    logic overflow;

    bcd4_adder dut (
        .a3(a3), .a2(a2), .a1(a1), .a0(a0),
        .b3(b3), .b2(b2), .b1(b1), .b0(b0),
        .r3(r3), .r2(r2), .r1(r1), .r0(r0),
        .overflow(overflow)
    );

    initial begin
        $dumpfile("tb_bcd4_adder.vcd");
        $dumpvars(0, tb_bcd4_adder);

        test_sum(4'd1,4'd2,4'd3,4'd4, 4'd0,4'd4,4'd5,4'd6, 4'd1,4'd6,4'd9,4'd0);
        test_sum(4'd0,4'd9,4'd9,4'd9, 4'd0,4'd9,4'd9,4'd9, 4'd1,4'd9,4'd9,4'd8);
        test_sum(4'd0,4'd0,4'd0,4'd0, 4'd0,4'd0,4'd0,4'd0, 4'd0,4'd0,4'd0,4'd0);
        test_sum(4'd1,4'd1,4'd1,4'd1, 4'd2,4'd2,4'd2,4'd2, 4'd3,4'd3,4'd3,4'd3);
        test_sum(4'd5,4'd0,4'd0,4'd0, 4'd4,4'd0,4'd0,4'd0, 4'd9,4'd0,4'd0,4'd0);

        $display("FIN tb_bcd4_adder");
        $finish;
    end

    task test_sum(
        input logic [3:0] ta3, ta2, ta1, ta0,
        input logic [3:0] tb3, tb2, tb1, tb0,
        input logic [3:0] er3, er2, er1, er0
    );
        begin
            a3 = ta3; a2 = ta2; a1 = ta1; a0 = ta0;
            b3 = tb3; b2 = tb2; b1 = tb1; b0 = tb0;

            #10;

            if ({r3,r2,r1,r0} == {er3,er2,er1,er0})
                $display("OK: %0d%0d%0d%0d + %0d%0d%0d%0d = %0d%0d%0d%0d",
                         ta3,ta2,ta1,ta0,tb3,tb2,tb1,tb0,r3,r2,r1,r0);
            else
                $display("ERROR: esperado %0d%0d%0d%0d, obtenido %0d%0d%0d%0d",
                         er3,er2,er1,er0,r3,r2,r1,r0);
        end
    endtask

endmodule