module keypad_reader (
    input  logic clk,
    input  logic rst_n,
    output logic [3:0] filas,
    input  logic [3:0] columnas,
    output logic [3:0] key_value,
    output logic       key_valid
);

    parameter integer SCAN_DELAY    = 27000;
    parameter integer RELEASE_DELAY = 200000;

    logic [1:0]  fila_index;
    logic [15:0] scan_cnt;
    logic [17:0] release_cnt;

    logic [3:0] columnas_ff1;
    logic [3:0] columnas_sync;

    logic [3:0] col_read;
    logic [3:0] key_code;
    logic       detected;
    logic       locked;

    // Sincronizador de 2 flip-flops para entradas asíncronas del teclado
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            columnas_ff1  <= 4'hF;
            columnas_sync <= 4'hF;
        end else begin
            columnas_ff1  <= columnas;
            columnas_sync <= columnas_ff1;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scan_cnt <= 0;
            fila_index <= 0;
        end else if (!locked) begin
            if (scan_cnt == SCAN_DELAY - 1) begin
                scan_cnt <= 0;
                fila_index <= fila_index + 1;
            end else begin
                scan_cnt <= scan_cnt + 1;
            end
        end
    end

    always_comb begin
        case (fila_index)
            2'd0: filas = 4'b1110; // * 0 # D
            2'd1: filas = 4'b1101; // 7 8 9 C
            2'd2: filas = 4'b1011; // 4 5 6 B
            2'd3: filas = 4'b0111; // 1 2 3 A
            default: filas = 4'b1111;
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            col_read <= 4'hF;
        else
            col_read <= columnas_sync;
    end

    always_comb begin
        key_code = 4'h0;
        detected = 1'b0;

        case (fila_index)
            2'd0: begin
                case (col_read)
                    4'hE: begin key_code = 4'hE; detected = 1'b1; end // *
                    4'hD: begin key_code = 4'h0; detected = 1'b1; end // 0
                    4'hB: begin key_code = 4'hF; detected = 1'b1; end // #
                    4'h7: begin key_code = 4'hD; detected = 1'b1; end // D
                    default: detected = 1'b0;
                endcase
            end

            2'd1: begin
                case (col_read)
                    4'hE: begin key_code = 4'h7; detected = 1'b1; end
                    4'hD: begin key_code = 4'h8; detected = 1'b1; end
                    4'hB: begin key_code = 4'h9; detected = 1'b1; end
                    4'h7: begin key_code = 4'hC; detected = 1'b1; end
                    default: detected = 1'b0;
                endcase
            end

            2'd2: begin
                case (col_read)
                    4'hE: begin key_code = 4'h4; detected = 1'b1; end
                    4'hD: begin key_code = 4'h5; detected = 1'b1; end
                    4'hB: begin key_code = 4'h6; detected = 1'b1; end
                    4'h7: begin key_code = 4'hB; detected = 1'b1; end
                    default: detected = 1'b0;
                endcase
            end

            2'd3: begin
                case (col_read)
                    4'hE: begin key_code = 4'h1; detected = 1'b1; end
                    4'hD: begin key_code = 4'h2; detected = 1'b1; end
                    4'hB: begin key_code = 4'h3; detected = 1'b1; end
                    4'h7: begin key_code = 4'hA; detected = 1'b1; end
                    default: detected = 1'b0;
                endcase
            end

            default: detected = 1'b0;
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            key_value <= 4'd0;
            key_valid <= 1'b0;
            locked <= 1'b0;
            release_cnt <= 0;
        end else begin
            key_valid <= 1'b0;

            if (!locked && detected) begin
                key_value <= key_code;
                key_valid <= 1'b1;
                locked <= 1'b1;
                release_cnt <= 0;
            end else if (locked) begin
                if (col_read == 4'hF) begin
                    if (release_cnt < RELEASE_DELAY)
                        release_cnt <= release_cnt + 1;
                    else begin
                        locked <= 1'b0;
                        release_cnt <= 0;
                    end
                end else begin
                    release_cnt <= 0;
                end
            end
        end
    end

endmodule