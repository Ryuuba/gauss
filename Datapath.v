`ifndef DATAPATH_V
`define DATAPATH_V

//Author: Adán G. Medrano-Chávez
//This datapath computes n(n+1)/2 through sums. Silly, isn't it?

module Datapath(
  ctrlword,     //Manages register i, n, and acum as well as the output
  data,         //Input value
  status,       //Indicates whether the loop continues or not
  done,         //Indicates the result is ready
  result,       //n(n+1)/2
  clk           //Clock signal
);

  //This parameter defines the width of the operand and the result
  parameter width = 16;

  input wire[3:0] ctrlword; //control bits are output, count, load_a, init
  input wire[width-1:0] data; //input value
  input wire clk;
  output reg status, done;
  output wire[width-1:0] result;

  //Internal register storing the value of the variables.
  reg[width-1:0] i, n, acum;

  //Here the behavior of register is described according to the control word.
  //The case corresponding to state three needs 'n' tri-state buffers, so it's
  //described in a generate block
  always @(posedge clk) begin
    case (ctrlword)
      4'b0001:  begin
                  n <= data;
                  acum <= 0;
                  i <= 1;
                end
      4'b0010: acum <= acum + i;
      4'b0100: i <= i + 1;
    endcase
  end

  //This case avoids writting n lines describing n tristate buffers
  genvar j;
  generate
    for (j = 0; j < width; j = j + 1) begin
      assign result[j] = (ctrlword[3]) ? acum[j] : 1'bz;
    end
  endgenerate

  //Here the combinational blocks of the datapath is described. The actual
  //inputs modifying the output of this block are only registers i and n as well
  //as the most significant bit of the control word
  always @(i or n or ctrlword[3]) begin
    done = ctrlword[3];
    if (i <= n)
      status = 1;
    else
      status = 0;
  end

endmodule // Datapath

`endif