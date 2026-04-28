module registro_num (
    input  logic clk,
    input  logic reset,
    input  logic load,          // habilita ingreso
    input  logic [3:0] digit,   // número ingresado (0–9)
    output logic [11:0] number  // hasta 999
);

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        number <= 0;
    else if (load)
        number <= number * 10 + digit;
end

endmodule