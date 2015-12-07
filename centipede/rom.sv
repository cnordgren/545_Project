module rom(input logic [13:0] address,
	   input logic ena_l,
	   input logic clk,
	  output logic [7:0] data);

	logic [7:0] ROM [16383:0];
	$readmemh("centipedeROM.hex", ROM);

	always_ff @(posedge clk) begin
		if(ena_l)
			data <= 8'bzzzz_zzzz;
		else
			data <= ROM[address];
	end
endmodule
