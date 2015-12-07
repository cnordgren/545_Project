module	trackball(input logic [1:0] hordir, 
            input logic [1:0]  horclk, 
            input  logic [1:0]  verdir, 
            input  logic [1:0]  verclk,
			 input logic rstclr_l, steerclr, flip,
			output logic dir1, dir2,
			output logic [3:0] tra, 
			output logic [3:0] trb);

	// Horizontal Flip Flop
	always_ff @(posedge horclk[flip], negedge rstclr_l) begin
		if(~rstclr_l)
			dir1 <= 1'b0;
		else
			dir1 <= hordir[flip];
	end

	// Vertical Flip Flop
	always_ff @(posedge verclk[flip], negedge rstclr_l) begin
		if(~rstclr_l)
			dir2 <= 1'b0;
		else
			dir2 <= verdir[flip];
	end

	logic mmh, mmv, riph, ripv;

	LS191 horcounter	(.CTEN(1'b0), .DU(dir1), .clk(horclk[flip]), .load(steerclr),
				.a(1'b0), .b(1'b0), .c(1'b0), .d(1'b0), .MaxMin(mmh), .RCO(riph),
				.qa(tra[0]), .qb(tra[1]), .qc(tra[2]), .qd(tra[3]));

	LS191 vercounter	(.CTEN(1'b0), .DU(dir2), .clk(verclk[flip]), .load(steerclr),
				.a(1'b0), .b(1'b0), .c(1'b0), .d(1'b0), .MaxMin(mmv), .RCO(ripv),
				.qa(trb[0]), .qb(trb[1]), .qc(trb[2]), .qd(trb[3]));
				
endmodule

