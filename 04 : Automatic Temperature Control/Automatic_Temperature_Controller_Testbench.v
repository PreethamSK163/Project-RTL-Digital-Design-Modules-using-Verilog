`timescale 1ns/1ps
module atc_tb;

  // Simulation parameters for environmental behavior
  parameter integer HEATER_CYCLE_DELAY = 10;   // Heater operates every 10 cycles
  parameter integer COOLER_CYCLE_DELAY = 5;    // Cooler operates every 5 cycles
  parameter integer HEATER_STEP = 2;           // Temperature increment per heater cycle
  parameter integer COOLER_STEP = 3;           // Temperature decrement per cooler cycle
  parameter integer CLK_PERIOD = 10;           // Clock period in nanoseconds

  // Inputs to DUT
  reg clk, reset;
  reg [7:0] c_temp, d_temp;
  reg [3:0] temp_tol;

  // Outputs from DUT
  wire ht_on, cl_on;

  // Instantiate the device under test (DUT)
  auto_temp_controller atc_inst (
    .clk(clk),
    .reset(reset),
    .current_temp(c_temp),
    .desired_temp(d_temp),
    .temp_tolerance(temp_tol),
    .heater_on(ht_on),
    .cooler_on(cl_on)
  );

  // Clock generation logic
  always #(CLK_PERIOD/2) clk = ~clk;

  // Environment simulation counters
  reg [31:0] heat_tick, cool_tick;

  // Simulate how the environment responds to heater and cooler
  always @(posedge clk) begin
    if (reset) begin
      heat_tick <= 0;
      cool_tick <= 0;
    end else begin
      // Track how long heater has been ON
      if (ht_on)
        heat_tick <= heat_tick + 1;
      else
        heat_tick <= 0;

      // Track how long cooler has been ON
      if (cl_on)
        cool_tick <= cool_tick + 1;
      else
        cool_tick <= 0;

      // Simulate temperature increase if heater is ON
      if (ht_on && (heat_tick % HEATER_CYCLE_DELAY == 0)) begin
        c_temp <= c_temp + HEATER_STEP;
      end

      // Simulate temperature decrease if cooler is ON
      if (cl_on && (cool_tick % COOLER_CYCLE_DELAY == 0)) begin
        c_temp <= c_temp - COOLER_STEP;
      end
    end
  end

  // Task to perform and validate a test case
  task automatic test_case(
    input [7:0] init_temp, 
    input [7:0] set_temp, 
    input [31:0] wait_time
  );
    begin
      $display("\n🔍 Starting test case: current=%0d, desired=%0d", init_temp, set_temp);
      c_temp = init_temp;
      d_temp = set_temp;
      #wait_time;

      // Check if final temperature is within tolerance and both heater/cooler are OFF
      if ((ht_on === 1'b0 && cl_on === 1'b0) &&
          (c_temp >= d_temp - temp_tol && c_temp <= d_temp + temp_tol)) begin
        $display("✅ Test case passed. Final Temperature = %0d", c_temp);
      end else begin
        $display("❌ Temperature did not stabilize within tolerance. Final Temperature = %0d", c_temp);
      end
    end
  endtask

  // Test sequence
  initial begin
    // Initialization
    clk      = 1'b0;
    reset    = 1'b1;
    c_temp   = 0;
    d_temp   = 0;
    temp_tol = 4'd2;

    #100;         // Hold reset for a while
    reset = 1'b0; // Release reset

    // Run various test cases
    test_case(60, 70, 1500);  // Heating up
    test_case(80, 70, 1500);  // Cooling down
    test_case(40, 70, 3000);  // Cold winter scenario
    test_case(95, 70, 3000);  // Hot summer scenario

    $display("🎉 All tests completed.");
    #100;
    $stop;
  end

  // Continuous monitoring of temperature and controller outputs
  initial begin
    $monitor($time, 
             " ns | current_temp=%d, desired_temp=%d, heater_on=%b, cooler_on=%b",
             c_temp, d_temp, ht_on, cl_on);
  end

  // Generate VCD waveform dump for viewing in GTKWave or ModelSim
  initial begin
    $dumpfile("atc_tb.vcd");
    $dumpvars(0, atc_tb);
  end

endmodule
