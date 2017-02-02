`include "Processor.v"
`timescale 1ns/100ps

//Author: Adán G. Medrano-Chávez
//This testbench evaluates the functionality of a processor

module Testbench;
  //This parameter determines the width of both the input operand and the result
  parameter width = 16;

  reg[width-1:0] data;
  reg preset, clk;

  wire[width-1:0] result;
  wire done;

  defparam proc.width = width;
  Processor proc(data, clk, preset, result, done);

  //Generation of clock signal
  always #1 clk = ~clk;

  //The simulation is described in an initial block. As the always block, you
  //can use high level instructions here
  initial begin
    //The following two instructions set the result of the simulation,
    //All testbench using iverilog used them
    $dumpfile("gauss.vcd");
    $dumpvars(0, Testbench);
    //The value of each input is stated from here
    clk = 0;
    data = 10;
    preset = 0;
    #0.5; //This is a delay of 0.5 ns
    preset = 1;
    #1.5;
    preset = 0;
    #44;
    data = 5;
    #24;
    $finish; //The simulation finishes with this instruction
  end
endmodule // Testbench