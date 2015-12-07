module centipede(input logic clk,
		 input logic [15:0] sw,
		 input logic btnU, btnR, btnL,
		 input logic [7:0] JA,
		output logic ampPWM,
		output logic [3:0] vgaRed, vgaBlue, vgaGreen,
		output logic Hsync, Vsync);
   //SIGNALS
   //INTERNAL SIGNALS
   logic [15:0] addr;							//Address
   tri [7:0] 	data;							//Master data bus
   logic 	cpu_we_l;						//CPU Write Line
   logic [7:0]	cpuDout, ramDout, romDout, graphicsDout, pokeyDout;	//Data Outputs
   logic boardclk;							//Board clock
   logic clk_1_5;							//1.5 MHz clock
   logic clk_50;							//50 MHz clock
   logic clk_100;							//100 MHz clock
   logic PFRAMRD;                                                       //Playfield read to RAM
   logic STEERCLR;                                                      //Refreshes trackball counters each time they're checked
   logic SWRD;                                                          //Gets all option inputs
   logic IN0; 								//READS buttons
   logic POKEY; 							//POKEY enable
   logic ROM;								//Read from the ROM
   logic RAM0;								//RAM enable
   //INPUT SIGNALS
   logic [15:0] optSwitches;						//Options switches
   logic startGame, shoot;						//Buttons
   logic hordir1, horclk1, verdir1, verclk1;				//Player 1 trackball lines
   logic resetSystem;							//Reset
   //OUTPUT SIGNALS
   logic audioSignal;							//Output for sound
   logic [7:0] red, blue, green;					//VGA Colors
   logic vgaHsync, vgaVsync;						//VGA Sync Signals
   logic alteraVGAblank, alteraVGAclk, alterVGAsync;			//Altera VGA Signals

   //ASSIGN I/O SIGNALS TO BOARD PORTS
   assign boardclk = clk;
   assign optSwitches = sw;
   assign startGame = btnU;
   assign shoot = btnR;
   assign hordir1 = JA[0];
   assign horclk1 = JA[1];
   assign verdir1 = JA[2];
   assign verclk1 = JA[3];
   assign resetSystem = btnL;
   assign ampPWM = audioSignal;
   assign vgaRed = red[3:0];
   assign vgaBlue = blue[3:0];
   assign vgaGreen = green[3:0];
   assign Hsync = vgaHsync;
   assign Vsync = vgaVsync;

   // Creating clocks
   assign clk_100 = boardclk;
   always_ff @(posedge clk_100) begin
	clk_50 <= ~clk_50;
   end
   logic [5:0] count;
   always_ff @(posedge clk_100) begin
	if(count != 6'd33)
		count <= count + 1;
	else begin
		count <= 6'd0;
		clk_1_5 <= ~clk_1_5;
	end
   end

   //6502 CPU
   cpu sixty502(.clk(clk_1_5), .reset(~resetSystem), .AB(addr), .DI(data), .DO(cpuDout), .WE(cpu_we_l), .IRQ(1'b0), 
		.NMI(1'b1), .RDY(1'b1));
   assign data = (~POKEY) ? cpuDout : 8'bzzzz_zzzz;

   //RAM
   ram centipedeRAM(.addr(addr[9:0]), .write_l(cpu_we_l), .en_l(RAM0), .clk(clk_50), .dataBus(data));

   //ROM
   rom centipedeROM(.address(addr[13:0]), .ena_l(ROM), .data(data));
   
   //GRAPHICS
   graphicsPipeline gp(.clk(clk_50), .addr(addr), .data_in(data), .data_out(graphicsDout), .rst_l(~resetSystem),
		       .VGA_R(red), .VGA_B(blue), .VGA_G(green), .VGA_HS(vgaHsync), .VGA_VS(vgaVsync), 
		       .VGA_BLANK_N(alteraVGAblank), .VGA_CLK(alteraVGAclk), .VGA_SYNC_N(alteraVGAsync));
   assign data = (PFRAMRD) ? graphicsDout : 8'bzzzz_zzzz;		       
		     
   //ADDRESS DECODER
   logic WRITE_2;
   logic WATCHDOG, OUT0, IRQRES;
   logic PF, COLORRAM, NinetyNine, EA_READ;
   logic EA_CONTROL, EA_ABOR;
   logic [3:0] rom, PFWR;
   address_decoder  ad(.AB(addr), .WRITE(cpu_we_l), .BR_W(~cpu_we_l), .GMHZ(1'b0), .PAC(1'b0),
			.ROM(ROM), .WRITE_2(WRITE_2), .rom(rom), .STEERCLR(STEERCLR), 
                          .WATCHDOG(WATCHDOG), .OUT0(OUT0), .IRQRES(IRQRES), .POKEY(POKEY), .SWRD(SWRD), .PF(PF), .RAM0(RAM0), .COLORRAM(COLORRAM), .NinetyNine
(NinetyNine), .EA_READ(EA_READ), .EA_CONTROL(EA_CONTROL), .EA_ABOR(EA_ABOR), .IN0(IN0), .IN1(IN1), .PFRAMRD(PFRAMRD), .PFWR(PFWR));

   //AUDIO
   POKEY pokey(.Din(data), .Dout(pokeyDout), .A(addr[3:0]), .P(8'hF), .phi2(clk_1_5),
	       .readHighWriteLow(cpu_we_l), .cs0Bar(POKEY), .aud(audioSignal), .clk(clk_100));
   assign data = (cpu_we_l) ? pokeyDout : 8'bzzzz_zzzz;
   
   //INPUT
   input_network in(.ops1(optSwitches[7:0]), .ops2(optSwitches[15:8]),				// OPTION SWITCH BANKS
   		    .readops_l(SWRD),								// READS OPTIONS TO DATA BUS
		    .vblank(alteraVGAblank),							// VBLANK?
		    .start1(startGame), .fire1(shoot),						// PLAYER 1 BUTTONS
		    .readbut_l(IN0),								// READS BUTTONS TO DATA BUS
		    .seltri(addr[0]),								// CONTROLS MUXES IN INPUT CIRCUITRY
		    .hordir1(hordir1), .horclk1(horclk1), .verdir1(verdir1), .verclk1(verclk1),	// PLAYER 1 TRACKBALL
		    .trackrst_l(1'b1), .steerclr(STEERCLR), .ballselect(1'b0),			// CONTROL SIGNALS FOR TRACKBALL READER
		    .data_out(data),								// DATA OUT
		    .joy1(4'd0), .joy2(4'd0),							// JOYSTICKS, HELD LOW
		    .readjoy_l(1'b1),								// READS JOYSTICKS TO DATA BUS, HELD HIGH
		    .coinR(1'b0), .coinL(1'b0), .coinC(1'b0),					// COIN INPUTS, HELD LOW
		    .start2(1'b0), .fire2(1'b0),						// PLAYER 2 BUTTONS, HELD LOW
		    .hordir2(1'b0), .horclk2(1'b0), .verdir2(1'b0), .verclk2(1'b0));		// PLAYER 2 TRACKBALL, HELD LOW
   

endmodule: centipede
