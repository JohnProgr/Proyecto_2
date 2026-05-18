module fsm_top (
    input  logic clk,
    input  logic rst_n,

    output logic [3:0] filas,
    input  logic [3:0] columnas,

    output logic [6:0] seven,
    output logic [3:0] anodo
);

    typedef enum logic [1:0] {
        S_INPUT_A,
        S_INPUT_B,
        S_RESULT
    } state_t;

    state_t state;

    logic [3:0] key_value;
    logic       key_valid;

    logic [3:0] a3, a2, a1, a0;
    logic [3:0] b3, b2, b1, b0;

    logic [3:0] r3, r2, r1, r0;
    logic       overflow;

    logic [3:0] d3, d2, d1, d0;

    keypad_reader keypad_inst (
        .clk(clk),
        .rst_n(rst_n),
        .filas(filas),
        .columnas(columnas),
        .key_value(key_value),
        .key_valid(key_valid)
    );

    bcd4_adder adder_inst (
        .a3(a3), .a2(a2), .a1(a1), .a0(a0),
        .b3(b3), .b2(b2), .b1(b1), .b0(b0),
        .r3(r3), .r2(r2), .r1(r1), .r0(r0),
        .overflow(overflow)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_INPUT_A;

            a3 <= 4'd0;
            a2 <= 4'd0;
            a1 <= 4'd0;
            a0 <= 4'd0;

            b3 <= 4'd0;
            b2 <= 4'd0;
            b1 <= 4'd0;
            b0 <= 4'd0;
        end else if (key_valid) begin
            case (state)

                S_INPUT_A: begin
                    case (key_value)

                        4'hE: begin // *
                            state <= S_INPUT_B;

                            b3 <= 4'd0;
                            b2 <= 4'd0;
                            b1 <= 4'd0;
                            b0 <= 4'd0;
                        end

                        4'd0, 4'd1, 4'd2, 4'd3, 4'd4,
                        4'd5, 4'd6, 4'd7, 4'd8, 4'd9: begin
                            a3 <= a2;
                            a2 <= a1;
                            a1 <= a0;
                            a0 <= key_value;
                        end

                        default: begin
                            state <= S_INPUT_A;
                        end

                    endcase
                end

                S_INPUT_B: begin
                    case (key_value)

                        4'hF: begin // #
                            state <= S_RESULT;
                        end

                        4'hE: begin // * limpia B
                            b3 <= 4'd0;
                            b2 <= 4'd0;
                            b1 <= 4'd0;
                            b0 <= 4'd0;
                        end

                        4'd0, 4'd1, 4'd2, 4'd3, 4'd4,
                        4'd5, 4'd6, 4'd7, 4'd8, 4'd9: begin
                            b3 <= b2;
                            b2 <= b1;
                            b1 <= b0;
                            b0 <= key_value;
                        end

                        default: begin
                            state <= S_INPUT_B;
                        end

                    endcase
                end

                S_RESULT: begin
                    case (key_value)

                        4'd0, 4'd1, 4'd2, 4'd3, 4'd4,
                        4'd5, 4'd6, 4'd7, 4'd8, 4'd9: begin
                            state <= S_INPUT_A;

                            a3 <= 4'd0;
                            a2 <= 4'd0;
                            a1 <= 4'd0;
                            a0 <= key_value;

                            b3 <= 4'd0;
                            b2 <= 4'd0;
                            b1 <= 4'd0;
                            b0 <= 4'd0;
                        end

                        4'hE: begin // * pasa otra vez a B
                            state <= S_INPUT_B;

                            b3 <= 4'd0;
                            b2 <= 4'd0;
                            b1 <= 4'd0;
                            b0 <= 4'd0;
                        end

                        default: begin
                            state <= S_RESULT;
                        end

                    endcase
                end

                default: begin
                    state <= S_INPUT_A;
                end

            endcase
        end
    end

    always_comb begin
        case (state)

            S_INPUT_A: begin
                d3 = a3;
                d2 = a2;
                d1 = a1;
                d0 = a0;
            end

            S_INPUT_B: begin
                d3 = b3;
                d2 = b2;
                d1 = b1;
                d0 = b0;
            end

            S_RESULT: begin
                d3 = r3;
                d2 = r2;
                d1 = r1;
                d0 = r0;
            end

            default: begin
                d3 = 4'd0;
                d2 = 4'd0;
                d1 = 4'd0;
                d0 = 4'd0;
            end

        endcase
    end

    display_mux4 display_inst (
        .clk(clk),
        .rst_n(rst_n),
        .d3(d3),
        .d2(d2),
        .d1(d1),
        .d0(d0),
        .seven(seven),
        .anodo(anodo)
    );

endmodule