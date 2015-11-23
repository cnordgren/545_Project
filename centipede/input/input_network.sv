module	input_network	(input logic [3:0] joy1, joy2,			//JOYSTICK
			 input logic readjoy_l,				//JOYSTICK
			 input logic [7:0] ops1, ops2,			//OPTIONS
			 input logic readops_l,				//OPTIONS
			 input logic coinR, coinC, coinL,		//PLAYER INPUT
			 input logic vblank,				//PLAYER INPUT
			 input logic start1, start2, fire1, fire2,	//PLAYER INPUT
			 input logic readbut_l,				//PLAYER INPUT
			 input logic seltri,				//AB0
			output logic [7:0] data_out);

	ls257 joystick1	(.a(4'd0), .b(joy1), .select(seltri),
			.read_l(readjoy_l), .out(data_out[7:4]));

	ls257 joystick2	(.a(4'd0), .b(joy2), .select(seltri),
			.read_l(readjoy_l), .out(data_out[3:0]));

	ls257 #(8) ops	(.a(ops1), .b(ops2), .select(seltri),
			.read_l(readops_l), .out(data_out));

	ls257 #(8) p_in	(.a({1'b0, vblank, 6'b110000}),
			.b({coinR, coinC, coinL, 1'b1, fire2, fire1, start1, start2}),
			.select(seltri), .read_l(readbut_l), .out(data_out));

endmodule:	input_network