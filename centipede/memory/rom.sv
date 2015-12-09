module rom(input logic [13:0] address,
	   input logic 	      ena_l,
	   input logic 	      clk, rst_l,
	   output logic [7:0] data);
   
   logic [7:0] 		    ROM [16383:0];
  
   initial begin
      $readmemh("./centipedeROM.hex", ROM);
   end
   
   always_ff @(posedge clk, negedge rst_l) begin
      if(~rst_l)
	data = 8'd0;
      else
	data <= ROM[address];
   end
endmodule
