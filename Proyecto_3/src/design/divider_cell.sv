`timescale 1ns/1ps

module divider_cell (
    input  logic r_i,
    input  logic b_i,
    input  logic cin_i,
    input  logic accept_i,

    output logic diff_o,
    output logic cout_o,
    output logic r_next_o
);

    logic [1:0] sum_result;

    assign sum_result = {1'b0, r_i} + {1'b0, ~b_i} + {1'b0, cin_i};

    assign diff_o = sum_result[0];
    assign cout_o = sum_result[1];

    assign r_next_o = (accept_i) ? diff_o : r_i;

endmodule