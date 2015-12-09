module ram(input logic [9:0]  addr,
	   input logic 	      write_l,
           input logic 	      en_l,
	   input logic 	      clk,
	   input logic [7:0]  dataIn,
           output logic [7:0] dataOut);

   logic [7:0] 		   RAM[1023:0];
   
   always_ff @(posedge clk) begin
      if(~en_l & ~write_l)
	RAM[addr] <= dataIn;
      dataOut <= RAM[addr];
      
   end

endmodule
