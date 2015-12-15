//`define TEST
module playfieldRAM(input logic        clk, rst_l, we_l, cs_l,
		    input logic [9:0]  addrA, 
		    input logic [9:0]  addrB,
		    input logic [7:0]  datain, 
		    output logic [7:0] dataA, dataB);
   
   logic [7:0] data[1024];
   
`ifndef TEST
   always_ff@(posedge clk) begin
      if(~rst_l)
	data <= '{default:8'd0};
      else if(~we_l && ~cs_l)
	data[addrA] <= datain;
      else
	data <= data;
      
   end
`else // !`ifndef TEST
   initial begin
      $readmemh("pfram.hex", data);
   end
`endif // !`ifndef TEST

   // Synchronous RAM outputs
   always_ff@(posedge clk) begin
      dataA <= data[addrA];
      dataB <= data[addrB];      
   end
  
endmodule: playfieldRAM

module encoder(input logic  [3:0] A,
	       output logic [1:0] Y);

   always_comb begin
      case(A)
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

	
