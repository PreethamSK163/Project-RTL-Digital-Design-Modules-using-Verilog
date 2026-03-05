module washing_machine(
  input clk, reset, start,
  input water_level_full, drain_empty,
  output reg fill_valve_on, drain_valve_on,
  output reg motor_cw, motor_off
);

  // State encoding using parameters (instead of typedef enum)
  parameter IDLE  = 3'b000;
  parameter FILL  = 3'b001;
  parameter WASH  = 3'b010;
  parameter DRAIN = 3'b011;
  parameter RINSE = 3'b100;
  parameter SPIN  = 3'b101;
  parameter END   = 3'b110;

  reg [2:0] state, next_state;

  // Timing parameters
  parameter WASH_TIME  = 200;
  parameter RINSE_TIME = 150;
  parameter SPIN_TIME  = 300;

  reg [15:0] timer;

  // Timer logic
  always @(posedge clk or posedge reset) begin
    if (reset)
      timer <= 0;
    else if (state == WASH || state == RINSE || state == SPIN)
      timer <= timer + 1;
    else
      timer <= 0;
  end

  // State transition logic
  always @(*) begin
    case (state)
      IDLE:   next_state = (start) ? FILL : IDLE;
      FILL:   next_state = (water_level_full) ? WASH : FILL;
      WASH:   next_state = (timer >= WASH_TIME) ? DRAIN : WASH;
      DRAIN:  next_state = (drain_empty) ? RINSE : DRAIN;
      RINSE:  next_state = (timer >= RINSE_TIME) ? SPIN : RINSE;
      SPIN:   next_state = (timer >= SPIN_TIME) ? END : SPIN;
      END:    next_state = IDLE;
      default:next_state = IDLE;
    endcase
  end

  // State register
  always @(posedge clk or posedge reset) begin
    if (reset)
      state <= IDLE;
    else
      state <= next_state;
  end

  // Output logic
  always @(*) begin
    // Default output
    fill_valve_on  = 0;
    drain_valve_on = 0;
    motor_cw       = 0;
    motor_off      = 0;

    case (state)
      IDLE:   motor_off      = 1;
      FILL:   fill_valve_on  = 1;
      WASH:   motor_cw       = 1;
      DRAIN:  drain_valve_on = 1;
      RINSE: begin
        fill_valve_on  = 1;
        motor_cw       = 1;
      end
      SPIN: begin
        drain_valve_on = 1;
        motor_cw       = 1;
      end
      END:    motor_off      = 1;
    endcase
  end

endmodule
