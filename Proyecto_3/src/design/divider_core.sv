`timescale 1ns/1ps

module divider_core (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       valid_i,
    input  logic [5:0] dividend_i,
    input  logic [3:0] divisor_i,

    output logic [5:0] quotient_o,
    output logic [3:0] remainder_o,
    output logic       div_zero_o,
    output logic       done_o
);

    typedef enum logic [1:0] {
        IDLE,
        CALC,
        DONE
    } state_t;

    state_t state_reg, state_next;

    logic [5:0] dividend_reg;
    logic [3:0] divisor_reg;

    logic [5:0] quotient_comb;
    logic [3:0] remainder_comb;
    logic       div_zero_comb;

    divider_comb comb_inst (
        .dividend_i  (dividend_reg),
        .divisor_i   (divisor_reg),
        .quotient_o  (quotient_comb),
        .remainder_o (remainder_comb),
        .div_zero_o  (div_zero_comb)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_reg    <= IDLE;
            dividend_reg <= 6'd0;
            divisor_reg  <= 4'd0;

            quotient_o   <= 6'd0;
            remainder_o  <= 4'd0;
            div_zero_o   <= 1'b0;
            done_o       <= 1'b0;
        end else begin
            state_reg <= state_next;
            done_o    <= 1'b0;

            case (state_reg)
                IDLE: begin
                    if (valid_i) begin
                        dividend_reg <= dividend_i;
                        divisor_reg  <= divisor_i;
                    end
                end

                CALC: begin
                    quotient_o  <= quotient_comb;
                    remainder_o <= remainder_comb;
                    div_zero_o  <= div_zero_comb;
                end

                DONE: begin
                    done_o <= 1'b1;
                end

                default: begin
                    done_o <= 1'b0;
                end
            endcase
        end
    end

    always_comb begin
        state_next = state_reg;

        case (state_reg)
            IDLE: begin
                if (valid_i) begin
                    state_next = CALC;
                end
            end

            CALC: begin
                state_next = DONE;
            end

            DONE: begin
                state_next = IDLE;
            end

            default: begin
                state_next = IDLE;
            end
        endcase
    end

endmodule