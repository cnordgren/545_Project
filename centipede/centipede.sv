`define ALTERA

`ifdef ALTERA
module centipede(
		 
		 );
	
	assign 
`else
module centipede(

		 );
`endif

   //INTERNAL SIGNALS
   logic [15:0] addr;							//Address
   tri [7:0] 	data;							//Master data bus
   logic 	cpu_we_l;						//CPU Write Line
   logic [7:0]	cpuDout, ramDout, romDout, graphicsDout, pokeyDout;	//Data Outputs
   //INPUT SIGNALS
   logic [15:0] optSwitches;						//Options switches
   logic startGame, shoot;						//Buttons
   logic hordir1, horclk1, verdir1, verclk1;				//Player 1 trackball lines
   //OUTPUT SIGNALS
   logic audioSignal;							//Output for sound
   

   cpu sixty502(.clk(), .reset(), .AB(addr), .DI(data), .DO(cpuDout), .WE(cpu_we_l), .IRQ(), 
		.NMI(1'b1), .RDY(1'b1));
   assign data = (~pokey_en_l) ? cpuDout : 8'bzzzz_zzzz;

   cpuRam ram();

   cpuRom rom();
   
   graphicsPipeline gp(.clk(clk), .addr(addr), .data_in(data), .data_out(graphicsDout), .rst_l(),
		       .VGA_R(), .VGA_B(), VGA_G(), .VGA_HS(), .VGA_VS(), 
		       .VGA_BLANK_N(), .VGA_CLK(), .VGA_SYNC_N());
   assign data = (______________________) ? graphicsDout : 8'bzzzz_zzzz;		       
		       
   // Address decoder FIX ME I NEED HELP
   address_decoder ad(.AB(addr), .WRITE(cpu_we_l), .BR_W(), .GMHZ());

   POKEY pokey(.Din(data), .Dout(pokeyDout), .A(addr[3:0]), .P(8'hF), .phi2(),
	       .readHighWriteLow(cpu_we_l), .cs0Bar(pokey_en_l), .aud(audioSignal), .clk(clk));
   assign data = (cpu_we_l) ? pokeyDout : 8'bzzzz_zzzz;
   
   input_network in(.ops1(optSwitches[7:0]), .ops2(optSwitches[15:0]),	// OPTION SWITCH BANKS
   		    .readops_l(),					// READS OPTIONS TO DATA BUS
		    .vblank(),						// VBLANK?
		    .start1(startGame), fire1(shoot),			// PLAYER 1 BUTTONS
		    .readbut_l(),					// READS BUTTONS TO DATA BUS
		    .seltri(addr[0]),					// CONTROLS MUXES IN INPUT CIRCUITRY
		    .hordir1(hordir1), .horclk1(horclk1), .verdir1(verdir1), .verclk1(verclk1),	// PLAYER 1 TRACKBALL
		    .trackrst_l(), .steerclr(), .ballselect(),		// CONTROL SIGNALS FOR TRACKBALL READER
		    .data_out(data),					// DATA OUT
		    .joy1(4'd0), .joy2(4'd0),				// JOYSTICKS, HELD LOW
		    .coinR(1'b0), .coinL(1'b0), .coinC(1'b0),		// COIN INPUTS, HELD LOW
		    .start2(1'b0), .fire2(1'b0),			// PLAYER 2 BUTTONS, HELD LOW
		    .hordir2(1'b0), .horclk2(1'b0), .verdir2(1'b0), .verclk2(1'b0));	// PLAYER 2 TRACKBALL, HELD LOW
   

endmodule: centipede
