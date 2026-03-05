module uart_rx #(
    parameter DATA_WIDTH = 8
)(
    input wire clk,
    input wire rst,
    input wire baud_tick,
    input wire rx_serial,
    output reg data_valid,
    output reg [DATA_WIDTH-1:0] data_out
);

    reg [2:0] state;
    reg [DATA_WIDTH-1:0] data_reg;
    reg [3:0] bit_counter;
    reg parity_received, parity_calculated;
    reg rx_sample;

    localparam IDLE = 3'b000, START_BIT = 3'b001, DATA_BITS = 3'b010, PARITY_BIT = 3'b011, STOP_BIT = 3'b100;

    always @(posedge clk) begin
        if (baud_tick)
            rx_sample <= rx_serial;
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else if (baud_tick)
            case (state)
                IDLE: if (rx_serial == 0) state <= START_BIT;
                START_BIT: state <= DATA_BITS;
                DATA_BITS: if (bit_counter == DATA_WIDTH - 1) state <= PARITY_BIT;
                PARITY_BIT: state <= STOP_BIT;
                STOP_BIT: state <= IDLE;
            endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_valid <= 0;
            data_out <= 0;
            bit_counter <= 0;
            parity_received <= 0;
            parity_calculated <= 0;
        end else if (baud_tick) begin
            data_valid <= 0;
            case (state)
                START_BIT: bit_counter <= 0;
                DATA_BITS: begin
                    data_reg[bit_counter] <= rx_sample;
                    bit_counter <= bit_counter + 1;
                end
                PARITY_BIT: parity_received <= rx_sample;
                STOP_BIT: begin
                    if (rx_sample == 1) begin
                        parity_calculated = ^data_reg;
                        if (parity_received == parity_calculated) begin
                            data_out <= data_reg;
                            data_valid <= 1;
                        end else $display("Parity error!");
                    end else $display("Stop bit error!");
                    bit_counter <= 0;
                end
            endcase
        end
    end

endmodule
