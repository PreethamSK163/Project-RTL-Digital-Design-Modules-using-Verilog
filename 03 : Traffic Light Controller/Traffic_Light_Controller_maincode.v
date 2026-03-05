module traffic_light_controller (
    input clk,
    input reset_n,
    input main_road_sensor,
    input side_road_sensor,
    output reg [1:0] main_road_light,
    output reg [1:0] side_road_light
);

    localparam [1:0] RED    = 2'b00, 
                     YELLOW = 2'b01,
                     GREEN  = 2'b11;

    // State encoding
    localparam [1:0] MAIN_GREEN   = 2'd0,
                     MAIN_YELLOW  = 2'd1,
                     SIDE_GREEN   = 2'd2,
                     SIDE_YELLOW  = 2'd3;

    reg [1:0] current_state, next_state;

    // Timer constants (simulation-friendly values)
    // For real hardware at 100 MHz, scale up by 1,000,000x
    parameter MAIN_GREEN_TIME          = 100;  // 1000 ns
    parameter YELLOW_TIME              = 20;   // 200 ns
    parameter SIDE_GREEN_TIME          = 50;   // 500 ns
    parameter MIN_MAIN_GREEN_HOLD_TIME = 30;   // 300 ns

    reg [31:0] timer_count;
    reg timer_done;

    // State and timer update
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= MAIN_GREEN;
            timer_count   <= 0;
        end else begin
            current_state <= next_state;
            if (timer_done)
                timer_count <= 0;
            else
                timer_count <= timer_count + 1;
        end
    end

    // Timer done logic
    always @(*) begin
        timer_done = 1'b0;
        case (current_state)
            MAIN_GREEN:
                if (timer_count >= MAIN_GREEN_TIME) timer_done = 1'b1;
            MAIN_YELLOW:
                if (timer_count >= YELLOW_TIME) timer_done = 1'b1;
            SIDE_GREEN:
                if (timer_count >= SIDE_GREEN_TIME) timer_done = 1'b1;
            SIDE_YELLOW:
                if (timer_count >= YELLOW_TIME) timer_done = 1'b1;
            default:
                timer_done = 1'b0;
        endcase
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;

        case (current_state)
            MAIN_GREEN: begin
                if (timer_count >= MAIN_GREEN_TIME)
                    next_state = MAIN_YELLOW;
                else if (timer_count >= MIN_MAIN_GREEN_HOLD_TIME && side_road_sensor)
                    next_state = MAIN_YELLOW;
            end

            MAIN_YELLOW: begin
                if (timer_done)
                    next_state = SIDE_GREEN;
            end

            SIDE_GREEN: begin
                if (timer_done || main_road_sensor)
                    next_state = SIDE_YELLOW;
            end

            SIDE_YELLOW: begin
                if (timer_done)
                    next_state = MAIN_GREEN;
            end

            default: next_state = MAIN_GREEN;
        endcase
    end

    // Output logic
    always @(*) begin
        main_road_light = RED;
        side_road_light = RED;

        case (current_state)
            MAIN_GREEN: begin
                main_road_light = GREEN;
                side_road_light = RED;
            end
            MAIN_YELLOW: begin
                main_road_light = YELLOW;
                side_road_light = RED;
            end
            SIDE_GREEN: begin
                main_road_light = RED;
                side_road_light = GREEN;
            end
            SIDE_YELLOW: begin
                main_road_light = RED;
                side_road_light = YELLOW;
            end
        endcase
    end

endmodule