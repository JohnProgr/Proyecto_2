module input_fsm (
    input  logic clk,
    input  logic rst_n,

    input  logic key_valid,
    input  logic [3:0] key_code,

    output logic [13:0] display_value
);

    logic [1:0] digit_count;

    logic is_digit;
    logic is_clear;

    assign is_digit = (key_code <= 4'd9);
    assign is_clear = (key_code == 4'hE); // *

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            display_value <= 14'd0;
            digit_count   <= 2'd0;
        end else begin
            if (key_valid) begin

                if (is_clear) begin
                    display_value <= 14'd0;
                    digit_count   <= 2'd0;
                end

                else if (is_digit && digit_count < 3) begin
                    display_value <= (display_value * 10) + key_code;
                    digit_count   <= digit_count + 1;
                end

            end
        end
    end

endmodule