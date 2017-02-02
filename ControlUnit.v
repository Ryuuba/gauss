`ifndef CONTROL_UNIT_V
`define CONTROL_UNIT_V

//Author: Adán G. Medrano-Chávez
//This is a FSM controlling a datapath implementing the sum of n

module ControlUnit(
  status,     //This signal indicates if the datapath is computing the sum of n
  ctrlword,   //Signals managing all control signals of the datapath
  clk,        //Clock signal
  preset      //Establishes FSM in its initial state, namely state 0
);

  input wire status, clk, preset;
  output wire[3:0] ctrlword;

  reg[3:0] state; //The memory of the FSM is internal
  wire[3:0] nextstate; //Bus connecting the nextstate comb logic with the mem

  //next state logic
  assign nextstate[0] = state[3];
  assign nextstate[1] = status & (state[0] | state[2]);
  assign nextstate[2] = state[1];
  assign nextstate[3] = ~status & (state[0] | state[2]);

  //Memory storing the state of the FSM
  always @(posedge clk) begin
    if (preset) state <= 4'b0001; //Preset is synchronous
    else state <= nextstate;
  end

  //output combologic. This is a special case since the control word equals 
  //the state of the FSM
  assign ctrlword = state;
  

endmodule // ControlUnit

`endif