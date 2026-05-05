module binary_adder (
    input  logic [10:0] a,
    input  logic [10:0] b,
    output logic [10:0] sum
);
    assign sum = a + b;
endmodule