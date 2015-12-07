module ram(input logic [9:0] addr,
	   input logic  write_l,
           input logic  en_l,
	   input logic clk,
           inout tri  dataBus);

	logic [7:0] RAM[1023:0];

	always_ff @(posedge clk) begin
		if(~en_l) begin
			if(~write_l)
				RAM[addr] <= dataBus;
			else
				dataBus <= RAM[addr];	
		end
		else 
			dataBus <= 8'bzzzz_zzzz;	
		
	end
endmodule
