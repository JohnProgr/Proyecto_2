module fsm_control (
    input  logic clk,
    input  logic reset,
    input  logic key_valid,
    input  logic [3:0] key_value,

    output logic load_num1,
    output logic load_num2,
    output logic do_sum,
    output logic clear
);

typedef enum logic [2:0] {
    IDLE,
    INGRESO_NUM1,
    INGRESO_NUM2,
    CALCULO,
    MOSTRAR
} state_t;

state_t state, next_state;

// Registro de estado
always_ff @(posedge clk or posedge reset) begin
    if (reset)
        state <= IDLE;
    else
        state <= next_state;
end

// Lógica de transición
always_comb begin
    next_state = state;

    case (state)

        IDLE: begin
            if (key_valid)
                next_state = INGRESO_NUM1;
        end

        INGRESO_NUM1: begin
            if (key_valid && key_value == 4'hA) // '#'
                next_state = INGRESO_NUM2;
        end

        INGRESO_NUM2: begin
            if (key_valid && key_value == 4'hA) // '#'
                next_state = CALCULO;
        end

        CALCULO: begin
            next_state = MOSTRAR;
        end

        MOSTRAR: begin
            if (key_valid)
                next_state = IDLE;
        end

    endcase
end

// Salidas
always_comb begin
    load_num1 = 0;
    load_num2 = 0;
    do_sum    = 0;
    clear     = 0;

    case (state)

        IDLE: begin
            clear = 1;
        end

        INGRESO_NUM1: begin
            if (key_valid)
                load_num1 = 1;
        end

        INGRESO_NUM2: begin
            if (key_valid)
                load_num2 = 1;
        end

        CALCULO: begin
            do_sum = 1;
        end

    endcase
end

endmodule