module ram(input logic [9:0] addr,
	       input logic  write_l,
           input logic  en_l,
	       input logic clk,
           inout tri [7:0] dataBus);

	logic [7:0] RAM[1023:0];

	always_ff @(posedge clk) begin
		if(~en_l & ~write_l)
				RAM[addr] <= dataBus;
	end
	
	assign dataBus = (~en_l & write_l) ? RAM[addr] : 8'bzzzz_zzzz;
endmodule
