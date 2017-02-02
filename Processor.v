`include "Datapath.v"
`include "ControlUnit.v"

module Processor(
  data,   //input data
  clk,    //clock signal
  preset, //signal setting the FSM memory in the state 0
  result, //output data
  done    //signal indicating the job is done
);

parameter width = 16;
input wire[width-1:0] data;
input wire clk, preset;
output wire[width-1:0] result;
output wire done;

wire[3:0] ctrlword;
wire status;

defparam datapath.width = width;
//Registers in datapath load values when the negative edge of clock occurs
Datapath datapath(ctrlword, data, status, done, result, ~clk);
ControlUnit ctrl_u(status, ctrlword, clk, preset);

endmodule // Processor