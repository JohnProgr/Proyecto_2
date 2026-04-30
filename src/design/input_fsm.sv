module input_fsm (
    input  logic clk,
    input  logic rst_n,

    input  logic key_valid,
    input  logic [3:0] key_code,

    output logic [13:0] display_value
);

    typedef enum logic [1:0] {
        S_NUM1,
        S_NUM2,
        S_RESULT
    } state_t;

    state_t state;

    logic [9:0] num1;
    logic [9:0] num2;
    logic [10:0] sum;

    logic [1:0] digits1;
    logic [1:0] digits2;

    logic is_digit;
    logic is_enter;
    logic is_clear;

    assign is_digit = key_code <= 4'd9;
    assign is_enter = key_code == 4'hF; // #
    assign is_clear = key_code == 4'hE; // *

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= S_NUM1;
            num1          <= 10'd0;
            num2          <= 10'd0;
            sum           <= 11'd0;
            digits1       <= 2'd0;
            digits2       <= 2'd0;
            display_value <= 14'd0;
        end else begin
            if (key_valid) begin
                if (is_clear) begin
                    state         <= S_NUM1;
                    num1          <= 10'd0;
                    num2          <= 10'd0;
                    sum           <= 11'd0;
                    digits1       <= 2'd0;
                    digits2       <= 2'd0;
                    display_value <= 14'd0;
                end else begin
                    case (state)

                        S_NUM1: begin
                            if (is_digit && digits1 < 3) begin
                                num1 <= (num1 * 10) + key_code;
                                display_value <= (num1 * 10) + key_code;
                                digits1 <= digits1 + 1;
                            end else if (is_enter) begin
                                state <= S_NUM2;
                                display_value <= 14'd0;
                            end
                        end

                        S_NUM2: begin
                            if (is_digit && digits2 < 3) begin
                                num2 <= (num2 * 10) + key_code;
                                display_value <= (num2 * 10) + key_code;
                                digits2 <= digits2 + 1;
                            end else if (is_enter) begin
                                sum <= num1 + num2;
                                display_value <= num1 + num2;
                                state <= S_RESULT;
                            end
                        end

                        S_RESULT: begin
                            if (is_enter) begin
                                state         <= S_NUM1;
                                num1          <= 10'd0;
                                num2          <= 10'd0;
                                sum           <= 11'd0;
                                digits1       <= 2'd0;
                                digits2       <= 2'd0;
                                display_value <= 14'd0;
                            end
                        end

                        default: begin
                            state <= S_NUM1;
                        end

                    endcase
                end
            end
        end
    end

endmodule