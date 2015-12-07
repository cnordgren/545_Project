module	input_network	(input logic [3:0] joy1, joy2,			//JOYSTICK
			 input logic readjoy_l,				//JOYSTICK
			 input logic [7:0] ops1, ops2,			//OPTIONS
			 input logic readops_l,				//OPTIONS
			 input logic coinR, coinC, coinL,		//PLAYER INPUT
			 input logic vblank,				//PLAYER INPUT
			 input logic start1, start2, fire1, fire2,	//PLAYER INPUT
			 input logic readbut_l,				//PLAYER INPUT
			 input logic seltri,				//AB0
			 input logic hordir1, horclk1, verdir1, verclk1,//TRACKBALL
			 input logic hordir2, horclk2, verdir2, verclk2,//TRACKBALL
			 input logic trackrst_l, steerclr, ballselect,	//TRACKBALL
			output logic [7:0] data_out);

	logic [3:0] tra, trb; //TRACKBALL
	logic dir1, dir2; //TRACKBALL

	logic selftest, cocktail, slam; //PLAYER INPUT
	assign selftest = 1;
	assign cocktail = 1;
	assign slam = 1;

	LS257 joystick1	(.a({dir2, 3'b000}), .b(joy1), .select(seltri),
			.read_l(readjoy_l), .out(data_out[7:4]));

	LS257 joystick2	(.a(trb), .b(joy2), .select(seltri),
			.read_l(readjoy_l), .out(data_out[3:0]));

	LS257 #(8) ops	(.a(ops1), .b(ops2), .select(seltri),
			.read_l(readops_l), .out(data_out));

	LS257 #(8) p_in	(.a({dir1, vblank, selftest, cocktail, tra}),
			.b({coinR, coinC, coinL, slam, fire2, fire1, start1, start2}),
			.select(seltri), .read_l(readbut_l), .out(data_out));

	trackball myball(.hordir({hordir1, hordir2}), .horclk({horclk1, horclk2}),
			.verdir({verdir1, verdir2}), .verclk({verclk1, verclk2}),
			.rstclr_l(trackrst_l), .steerclr(steerclr), .flip(ballselect),
			.dir1(dir1), .dir2(dir2), .tra(tra), .trb(trb));

endmodule:	input_network
