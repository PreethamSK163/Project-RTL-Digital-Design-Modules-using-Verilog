module auto_temp_controller (
  input       clk, reset,                  // Clock and active-high reset
  input [7:0] current_temp, desired_temp,  // Current and target temperatures
  input [3:0] temp_tolerance,              // Acceptable temperature deviation
  output reg  heater_on, cooler_on         // Control signals for heater and cooler
);

// State encoding using one-hot representation
localparam [2:0] IDLE    = 3'b001,
                 HEATING = 3'b010,
                 COOLING = 3'b100;

reg [2:0] state, next_state; // Current and next state registers

// State register logic (sequential block)
// On reset, go to IDLE state; otherwise, update state on clock edge
always @(posedge clk or posedge reset) begin
  if (reset)
    state <= IDLE;
  else
    state <= next_state;
end

// Next state logic (combinational block)
// Determines transitions based on current temperature and desired value
always @* begin
  case (state)
    IDLE: begin
      if (current_temp < (desired_temp - temp_tolerance))
        next_state = HEATING; // Too cold, turn on heater
      else if (current_temp > (desired_temp + temp_tolerance))
        next_state = COOLING; // Too hot, turn on cooler
      else
        next_state = IDLE;    // Within range, stay idle
    end

    HEATING: begin
      if (current_temp >= desired_temp)
        next_state = IDLE;    // Desired temp reached, go idle
      else
        next_state = HEATING; // Continue heating
    end

    COOLING: begin
      if (current_temp <= desired_temp)
        next_state = IDLE;    // Desired temp reached, go idle
      else
        next_state = COOLING; // Continue cooling
    end

    default: next_state = IDLE; // Default to IDLE on invalid state
  endcase
end

// Output logic (sequential block)
// Based on current state, control heater and cooler outputs
always @(posedge clk or posedge reset) begin
  if (reset) begin
    heater_on <= 1'b0;
    cooler_on <= 1'b0;
  end else begin
    case (state)
      IDLE: begin
        heater_on <= 1'b0;
        cooler_on <= 1'b0;
      end
      HEATING: begin
        heater_on <= 1'b1;
        cooler_on <= 1'b0;
      end
      COOLING: begin
        heater_on <= 1'b0;
        cooler_on <= 1'b1;
      end
    endcase
  end
end

endmodule

