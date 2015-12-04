`define SIM

module playfieldRAM(input clk, rst_l, we_l,
		    input [3:0]  cs
		    input [7:0]  addrA, addrB,
		    input [7:0]  datain, 
		    output [7:0] dataA, dataB);

   logic [1023:0][7:0] 		  data;
   logic [1:0] 			  addrTop;
   
   encoder csEnc(.A(cs), .Y(addrTop));
   
   always_ff@(posedge clk, negedge rst_l) begin
`ifdef SIM
      if(~rst_l)
	data <= 0;
      else if(~we)
	data[{addrTop, addrA}] <= datain;
`else
      if(~we)
	data[{addrTop, addrA}] <= datain;
`endif
   end

   assign dataA = data[{addrTop, addrA}];
   assign dataB = data[{addrTop, addrB}];
   
endmodule: playfieldRAM

module encoder(input [3:0] A,
	       output [1:0] Y);

   always_comb begin
      case(cs)
	4'b0000:
	  Y = 2'd0;
	4'b0010:
	  Y= 2'd1;
	4'b0100:
	  Y = 2'd2;
	4'b1000:
	  Y = 2'd3;
	default:
	  Y = 2'd0;
      endcase // case (cs)
   end // always_comb

endmodule: encoder

	
