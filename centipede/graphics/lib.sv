//lib.sv
`ifndef LIB
`define LIB
module range_check
  #(WIDTH = 8)
  (input logic [WIDTH-1:0] val, low, high,
   output logic is_between);

   always_comb begin
      if (low <= val && val <= high)
	is_between = 1'b1;
      else
	is_between = 1'b0;
   end
endmodule: range_check

module offset_check
  #(WIDTH = 8)
   (input logic [WIDTH-1:0] val, low, delta,
    output logic is_between);
   logic [WIDTH-1:0] high;
   logic 	     Cout;
   
   adder #(WIDTH) add(.Sum(high), .Cout(Cout), .A(low), .B(delta), .Cin(1'b0));
   range_check #(WIDTH) rc(.val(val), .low(low), .high(high), .is_between(is_between));

endmodule: offset_check

module comparator
  #(parameter WIDTH = 8)
   (output logic AltB, AeqB, AgtB,
    input logic [WIDTH-1:0] A, B);

   always_comb begin
      if (A < B) AltB = 1'b1;
      else AltB = 1'b0;

      if (A == B) AeqB = 1'b1;
      else AeqB = 1'b0;
      
      if (A > B) AgtB = 1'b1;
      else AgtB = 1'b0;
   end

endmodule: comparator

module PriorityEncoder
  (output logic [1:0] Y,
   input logic [2:0] A);

   always_comb begin
      if(A[2] == 1'b1) Y = 2'd3;
      else if (A[1] == 1'b1) Y = 2'd2;
      else if (A[0] == 1'b1) Y = 2'd1;
      else Y = 2'd0;
   end
endmodule: PriorityEncoder

module adder
  #(parameter WIDTH = 8)
   (output logic [WIDTH-1:0] Sum,
    output logic Cout,
    input logic [WIDTH-1:0] A, B,
    input logic Cin);

   assign {Cout, Sum} = A + B + Cin;

endmodule: adder

module mux
  #(parameter WIDTH = 8)
   (output logic Y,
    input logic [WIDTH-1:0] I,
    input logic [$clog2(WIDTH)-1:0] Sel);

   assign Y = I[Sel];

endmodule: mux

module mux4to1
  #(parameter WIDTH = 8)
   (output logic [WIDTH-1:0] Y,
    input logic [WIDTH-1:0] I0, I1, I2, I3,
    input logic [1:0] Sel);

   always_comb begin
      if (Sel == 2'd0) Y = I0;
      else if (Sel == 2'd1) Y = I1;
      else if (Sel == 2'd2) Y = I2;
      else Y = I3;
   end
endmodule: mux4to1

module mux2to1
  #(parameter WIDTH = 8)
   (output logic [WIDTH-1:0] Y,
    input logic [WIDTH-1:0] I0, I1,
    input logic Sel);

   always_comb begin
      if (Sel == 1'b1) Y = I1;
      else Y = I0;
   end

endmodule: mux2to1

module decoder
  #(parameter WIDTH = 8)
   (output logic [WIDTH-1:0] D,
    input logic [$clog2(WIDTH)-1:0] I,
    input logic en);

   always_comb begin
      D=0;
      if (en == 1)
	 D[I] = 1'b1;
      else D = 0;
   end

endmodule: decoder

module def_register
  #(parameter WIDTH = 8)  
   (output logic [WIDTH-1:0] Q,
    input logic [WIDTH-1:0] D, def,
    input logic clk, en, clr);
    
    always_ff @(posedge clk)
      if (~clr & en)
	Q <= D;
      else if (clr)
	Q <= def;       
    
endmodule: def_register
    
module register
  #(parameter WIDTH = 8)
   (output logic [WIDTH-1:0] Q,
    input logic [WIDTH-1:0] D,
    input logic clk, en, clr);
   
   always_ff @(posedge clk)
     if (~clr & en)
       Q <= D;
     else if (clr)
       Q <= 'b0;

endmodule: register

//clr takes precidence over en, load, & up
module counter
  #(WIDTH = 8)
   (input logic [WIDTH-1:0] D, limit,
    input logic en, clr, load, clk,
    output logic [WIDTH-1:0] Q);
   logic [WIDTH-1:0] 	     Qup;
   logic 		     at_limit;
   
   always_comb begin
      if (Q == limit)
	at_limit = 1;
      else
	at_limit = 0;
   end
   
   always_ff @(posedge clk, negedge clr) begin
      if (~clr)
	Q <= 'b0;
      else if (at_limit)
	Q <= 'b0;
      else if (en) begin
	 if (load)
	   Q <= D;
	 else
	   Q <= Qup;
      end
   end // always_ff @ (posedge clk)

   assign Qup = Q + 1'd1;

endmodule: counter

//adds s_in to either the left or right side of register
module shift_register
  #(WIDTH = 8)
   (input logic s_in, en, left, clk,
    output logic [WIDTH-1:0] Q);
   logic [WIDTH-1:0] 	     Qright, Qleft;

   //Add s_in to the most significant bit
   assign Qright = ((Q >> 1) | (s_in << WIDTH-1));

   //Add s_in to the least significant bit
   assign Qleft = ((Q << 1) | s_in);
   
   always_ff @(posedge clk) begin
      if (en) begin
	 if (left)
	   Q <= Qleft;
	 else
	   Q <= Qright;
      end
   end	
endmodule: shift_register

//For simulation purposes
module clock
  (output logic clk);

   initial begin
      clk = 0;
      forever #1 clk = ~clk;
   end
endmodule: clock

module latchl
  (input logic D, unlatch, clk, rst,
   output logic latched);

   always_ff @(posedge clk)
     if (rst)
       latched <= 0;
     else if (unlatch)
       latched <= 0;
     else if (D == 1)
       latched <= 1;

endmodule: latchl
`endif
