module calculator_top (
    input  logic clk,
    input  logic rst_n,

    // Teclado matricial 4x4
    output logic [3:0] filas,
    input  logic [3:0] columnas,

    // Display 7 segmentos
    output logic [6:0] seven,
    output logic [3:0] anodo,

    // Opcional
    //input  logic [3:0] dip_switch
);

    logic [3:0] key_value;
    logic       key_valid;

    logic [3:0] a2, a1, a0;
    logic [3:0] b2, b1, b0;

    logic [3:0] r3, r2, r1, r0;
    logic [3:0] d3, d2, d1, d0;

    logic load;
    logic start_conv;
    logic ready;

    logic [1:0] digit_count;

    typedef enum logic [2:0] {
        IDLE,
        LOAD_A,
        LOAD_B,
        LOAD_VALUES,
        START_SUM,
        SHOW_RESULT
    } state_t;

    state_t state;

    keypad_reader keypad_inst (
        .clk(clk),
        .rst_n(rst_n),
        .filas(filas),
        .columnas(columnas),
        .key_value(key_value),
        .key_valid(key_valid)
    );

    arithmetic_top adder_inst (
        .clk(clk),
        .rst_n(rst_n),
        .a2(a2), .a1(a1), .a0(a0),
        .b2(b2), .b1(b1), .b0(b0),
        .load(load),
        .start_conv(start_conv),
        .out_d3(r3), .out_d2(r2), .out_d1(r1), .out_d0(r0),
        .ready(ready)
    );

    display_mux4 display_inst (
        .clk(clk),
        .rst_n(rst_n),
        .d3(d3), .d2(d2), .d1(d1), .d0(d0),
        .seven(seven),
        .anodo(anodo)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            digit_count <= 0;

            a2 <= 0;
            a1 <= 0;
            a0 <= 0;

            b2 <= 0;
            b1 <= 0;
            b0 <= 0;

            load <= 0;
            start_conv <= 0;
        end else begin
            load <= 0;
            start_conv <= 0;

            case (state)

                IDLE: begin
                    digit_count <= 0;
                    a2 <= 0;
                    a1 <= 0;
                    a0 <= 0;
                    b2 <= 0;
                    b1 <= 0;
                    b0 <= 0;

                    if (key_valid) begin
                        a2 <= key_value;
                        digit_count <= 1;
                        state <= LOAD_A;
                    end
                end

                LOAD_A: begin
                    if (key_valid) begin
                        case (digit_count)
                            2'd1: begin
                                a1 <= key_value;
                                digit_count <= 2;
                            end

                            2'd2: begin
                                a0 <= key_value;
                                digit_count <= 0;
                                state <= LOAD_B;
                            end

                            default: begin
                                digit_count <= 0;
                            end
                        endcase
                    end
                end

                LOAD_B: begin
                    if (key_valid) begin
                        case (digit_count)
                            2'd0: begin
                                b2 <= key_value;
                                digit_count <= 1;
                            end

                            2'd1: begin
                                b1 <= key_value;
                                digit_count <= 2;
                            end

                            2'd2: begin
                                b0 <= key_value;
                                digit_count <= 0;
                                state <= LOAD_VALUES;
                            end

                            default: begin
                                digit_count <= 0;
                            end
                        endcase
                    end
                end

                LOAD_VALUES: begin
                    load <= 1;
                    state <= START_SUM;
                end

                START_SUM: begin
                    start_conv <= 1;
                    state <= SHOW_RESULT;
                end

                SHOW_RESULT: begin
                    if (key_valid) begin
                        state <= IDLE;
                    end
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    always_comb begin
        d3 = 0;
        d2 = 0;
        d1 = 0;
        d0 = 0;

        case (state)

            IDLE: begin
                d3 = 0;
                d2 = 0;
                d1 = 0;
                d0 = 0;
            end

            LOAD_A: begin
                d3 = 0;
                d2 = a2;
                d1 = a1;
                d0 = a0;
            end

            LOAD_B: begin
                d3 = 0;
                d2 = b2;
                d1 = b1;
                d0 = b0;
            end

            SHOW_RESULT: begin
                d3 = r3;
                d2 = r2;
                d1 = r1;
                d0 = r0;
            end

            default: begin
                d3 = r3;
                d2 = r2;
                d1 = r1;
                d0 = r0;
            end

        endcase
    end

endmodule