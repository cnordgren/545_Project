
module vga
  (input logic CLOCK_100, reset,
   output logic HS, VS, blank_N,
   output logic [8:0] row,
   output logic [9:0] col);
   logic [10:0]       clocks_H;
   logic [19:0]       clocks_V;
   logic 	      col_add, row_add, tdisp_H, tdisp_V, max_H;
   logic [1:0]	      clkDivOut;
   logic 	      CLOCK_50;
  
   assign CLOCK_50 = CLOCK_100;

   counter #(2) clkDiv(.D(2'd0), .limit(2'd3), .en(1'b1),
		       .clr(reset), .load(1'b0), .clk(CLOCK_100), .Q(clkDivOut));

   counter #(11) count_H(.D(11'd0), .limit(11'd1599), .en(1'b1), 
			 .clr(reset), .load(1'b0), .clk(CLOCK_50), .Q(clocks_H));
   
   counter #(10) cols(.D(10'd0), .limit(10'd640), .en(col_add),
		      .clr(reset), .load(1'b0), .clk(CLOCK_50), .Q(col));
   
   counter #(20) count_V(.D(20'd0), .limit(20'd833599), .en(1'b1),
			 .clr(reset), .load(1'b0), .clk(CLOCK_50), .Q(clocks_V));
   
   counter #(9) rows(.D(9'd0), .limit(9'd480), .en(row_add),
		     .clr(reset), .load(1'b0), .clk(CLOCK_50), .Q(row));

   range_check #(11) Tdisp_H(.val(clocks_H), .low(11'd288), .high(11'd1567),
			     .is_between(tdisp_H));
   range_check #(11) NTpw_H(.val(clocks_H), .low(11'd193), .high(11'd1599),
			    .is_between(HS));
   range_check #(20) Tdisp_V(.val(clocks_V), .low(20'd49888), .high(20'd817599),
			     .is_between(tdisp_V));
   range_check #(20) NTpw_V(.val(clocks_V), .low(20'd3201), .high(20'd833599),
			    .is_between(VS));

   comparator #(11) Max_H(.AeqB(max_H), .A(11'd1599), .B(clocks_H));
   
   assign blank_N = tdisp_H && tdisp_V;
   assign col_add = ~clocks_H[0] && tdisp_H;
   assign row_add = tdisp_V && max_H;
   
endmodule: vga

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
/*
module adder
  #(parameter WIDTH = 8)
   (output logic [WIDTH-1:0] Sum,
    output logic Cout,
    input logic [WIDTH-1:0] A, B,
    input logic Cin);

   assign {Cout, Sum} = A + B + Cin;

endmodule: adder
*/


    

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



/*
module test_display
  (input logic [9:0] col,
   input logic [8:0] row,
   output logic [7:0] VGA_R, VGA_G, VGA_B);
   
   always_comb begin
      if (10'd5 < row && row < 10'd150) begin
	 VGA_R = 8'hFF;
	 VGA_G = 8'h00;
	 VGA_B = 8'h00;
      end
      else if (10'd150 <= row && row < 10'd300) begin
	 VGA_R = 8'h00;
	 VGA_G = 8'hFF;
	 VGA_B = 8'h00;
      end
		else if (row == 10'd479 || row == 10'd2) begin
	 VGA_R = 8'hFF;
	 VGA_B = 8'hFF;
	 VGA_G = 8'hFF;
		end
      else begin
	 VGA_R = 8'h00;
	 VGA_G = 8'h00;
	 VGA_B = 8'hFF;
      end
   end // always_comb begin
   
endmodule: test_display
*/
/*
module test_vga;
   logic clk, reset, HS, VS, blank_N;
   logic [8:0] row;
   logic [9:0] col;
   logic [20:0] clocks;
   
   vga_opt1 v(.CLOCK_50(clk), .*);
   clock c(clk);
   counter #(21) clkC(.limit(21'd833599), .en(1'b1), .load(1'b0), .clr(reset), .clk(clk), .Q(clocks));
   

   initial begin
      $monitor("clocks=%d, reset=%b, HS=%b, VS=%b, blank_N=%b, row=%d, col=%d",
	       clocks, reset, HS, VS, blank_N, row, col);

      reset <= 1;
      @ (posedge clk);
      reset <= 0;
      for (int i = 0; i <2000000; i++)
	@ (posedge clk);
      @ (posedge clk);
      $finish;
   end // initial begin
endmodule: test_vga
*/
