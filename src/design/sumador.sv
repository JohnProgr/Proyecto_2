module sumador (
    input  logic clk,
    input  logic reset,
    input  logic enable,              // viene de do_sum
    input  logic [11:0] num1,
    input  logic [11:0] num2,
    output logic [12:0] result        // puede ser hasta 1998
);

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        result <= 0;
    else if (enable)
        result <= num1 + num2;
end

endmodule