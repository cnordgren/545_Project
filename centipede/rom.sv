module rom(input logic [13:0] address,
	       input logic ena_l,
//	       input logic clk,
	       output tri [7:0] data);

	logic [7:0] ROM [16383:0];
	initial begin
	   $readmemh("centipedeROM.hex", ROM);
	end

    assign data = (ena_l) ? 8'bzzzz_zzzz : ROM[address];

//	always_ff @(posedge clk) begin
//		if(ena_l)
//			data <= 8'bzzzz_zzzz;
//		else
//			data <= ROM[address];
//	end
endmodule
