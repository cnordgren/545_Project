module	LS257	#(parameter width = 4)
		(input logic [width-1:0] a, b,
		 input logic select, read_l,
		output logic [width-1:0] out);

	logic [width-1:0] data;

	assign data = (select) ? b : a;
	assign out = (read_l) ? 'z : data;

endmodule 
