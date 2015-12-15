//`define SIM1
module centipede(input logic CLOCK_50,
		 input logic [15:0] SW,
		 input logic [3:0]  KEY,
		 // GPIO LOGIC
		 //output logic 	    ampPWM,  AUDIO goes here
		 output logic [7:0] VGA_R, VGA_G, VGA_B,
		 output logic 	    VGA_HS, VGA_VS, VGA_CLK, VGA_BLANK_N, VGA_SYNC_N);
   //SIGNALS
   //INTERNAL SIGNALS
   logic [15:0] addr;							//Address
   tri [7:0] 	data;							//Master data bus
   logic 	cpu_we_l, cpu_we;					//CPU Write Line
   logic [7:0]	cpuDout, ramDout, romDout, graphicsDout, graphicsDoutSync, pokeyDout, cpuDataInSync;	//Data Outputs
   logic clk_1_5;							//1.5 MHz clock	        
   logic pfram_l;                                                       //Playfield read to RAM
   logic STEERCLR;                                                      //Refreshes trackball counters each time they're checked
   logic swrd_l;                                                        //Gets all option inputs
   logic IN0_l, IN1_l; 							//READS buttons
   logic POKEY; 							//POKEY enable
   logic ROM;								//Read from the ROM
   logic RAM0;								//RAM enable
   logic irq_res;
   logic irq;
   logic tb_flip;                                                       //Controls which trackball the cpu is reading
   //INPUT SIGNALS
   logic [15:0] optSwitches;						//Options switches
   logic startGame, shoot;						//Buttons
   logic hordir1, horclk1, verdir1, verclk1;				//Player 1 trackball lines
   logic resetSystem;							//Reset
   //OUTPUT SIGNALS
   logic audioSignal;							//Output for sound

   //ASSIGN I/O SIGNALS TO BOARD PORTS
   assign optSwitches = SW[15:0];
   assign startGame = ~KEY[3];
   assign shoot = ~KEY[2];
   //assign hordir1 = JA[0];
   //assign horclk1 = JA[1];
   //assign verdir1 = JA[2];
   //assign verclk1 = JA[3];
   assign resetSystem = KEY[0];
   //assign ampPWM = audioSignal;

   logic [$clog2(104167)-1:0] irqcount;
   assign irq = irqcount == 104166;

   // Generate IRQ
   always_ff@(posedge CLOCK_50, negedge resetSystem) begin
      if(~resetSystem)
	irqcount <= 0;
      else if(~irq_res)
	 irqcount <= 0;
      else if(irqcount != 104166)
	irqcount <= irqcount + 1;
   end
	
   // Creating clocks
   logic [5:0] count;
   always_ff @(posedge CLOCK_50) begin
      if(startGame) begin
	 count = 6'd0;
	 clk_1_5 = 1'b0;
      end
      else if(count != 6'd17)
	count <= count + 6'd1;
      else begin
	 count <= 6'd0;
	 clk_1_5 <= ~clk_1_5;
      end
   end

   assign cpu_we_l = ~cpu_we;
   
   //6502 CPU
   cpu sixty502(.clk(clk_1_5), .reset(~resetSystem), .AB(addr), .DI(cpuDataInSync), 
		.DO(cpuDout), .WE(cpu_we), .IRQ(irq), 
		.NMI(1'b0), .RDY(1'b1));
   register #(8) dinsync(.D(data), .Q(cpuDataInSync), .clk(CLOCK_50), .reset(1'b0),
			 .rst_l(resetSystem), .en(1'b1));
   assign data = (~cpu_we_l) ? cpuDout : 8'dz;

   //RAM
   ram centipedeRAM(.addr(addr[9:0]), .write_l(cpu_we_l), .en_l(RAM0), .rst_l(resetSystem),
		    .clk(clk_1_5), .dataOut(ramDout), .dataIn(data));
   assign data = (~RAM0 & cpu_we_l) ? ramDout : 8'dz;
   
   //ROM
   rom centipedeROM(.address(addr[13:0]), .ena_l(ROM), .data(romDout), .clk(clk_1_5), .rst_l(resetSystem));
   assign data = (~ROM & cpu_we_l) ? romDout : 8'dz;
   
   //GRAPHICS
   graphicsPipeline gp(.clk(CLOCK_50), .rst_l(resetSystem), .we_l(cpu_we_l), .cs_l(pfram_l),
		       .addr(addr), .data_in(data), .data_out(graphicsDout),
		       .VGA_R(VGA_R), .VGA_B(VGA_B), .VGA_G(VGA_G), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), 
		       .VGA_BLANK_N(VGA_BLANK_N), .VGA_CLK(VGA_CLK), .VGA_SYNC_N(VGA_SYNC_N));
   
   register #(8) gdreg(.D(graphicsDout), .Q(graphicsDoutSync), .clk(clk_1_5), .reset(1'b0),
		       .rst_l(resetSystem), .en(1'b1));
   
   assign data = (~pfram_l & cpu_we_l) ? graphicsDoutSync : 8'dz;		       
		     
   //ADDRESS DECODER
   address_decoder  ad(.addr(addr), .we_l(cpu_we_l),
		       .swrd_l(swrd_l), .steerclr_l(STEERCLR), .in0_l(IN0_l), 
		       .in1_l(IN1_l), .tb_flip(tb_flip),
		       .pfram_l(pfram_l), .pokey_l(POKEY), .rom_l(ROM), 
		       .ram_l(RAM0), .irq_l(irq_res));
		       
   //AUDIO
   //POKEY pokey(.Din(data), .Dout(pokeyDout), .A(addr[3:0]), .P(8'hF), .phi2(clk_1_5),
//	       .readHighWriteLow(cpu_we_l), .cs0Bar(POKEY), .aud(audioSignal), .clk(CLOCK_50));
  // assign data = (~POKEY & cpu_we_l) ? pokeyDout : 8'dz;
   
   //INPUT
/*   input_network in(.ops1(optSwitches[7:0]), .ops2(optSwitches[15:8]),				// OPTION SWITCH BANKS
   		    .readops_l(swrd_l),								// READS OPTIONS TO DATA BUS
		    .vblank(~VGA_BLANK_N),							// VBLANK?
		    .start1(startGame), .fire1(shoot),						// PLAYER 1 BUTTONS
		    .readbut_l(IN0_l),								// READS BUTTONS TO DATA BUS
		    .seltri(addr[0]),								// CONTROLS MUXES IN INPUT CIRCUITRY
		    .hordir1(hordir1), .horclk1(horclk1), .verdir1(verdir1), .verclk1(verclk1),	// PLAYER 1 TRACKBALL
		    .trackrst_l(1'b1), .steerclr(STEERCLR), .ballselect(tb_flip),			// CONTROL SIGNALS FOR TRACKBALL READER
		    .data_out(data),								// DATA OUT
		    .joy1(4'd0), .joy2(4'd0),							// JOYSTICKS, HELD LOW
		    .readjoy_l(1'b1),								// READS JOYSTICKS TO DATA BUS, HELD HIGH
		    .coinR(1'b0), .coinL(1'b0), .coinC(1'b0),					// COIN INPUTS, HELD LOW
		    .start2(1'b0), .fire2(1'b0),						// PLAYER 2 BUTTONS, HELD LOW
		    .hordir2(1'b0), .horclk2(1'b0), .verdir2(1'b0), .verclk2(1'b0));		// PLAYER 2 TRACKBALL, HELD LOW
  */ 

endmodule: centipede

`ifdef SIM1
module test();
   logic clk, rst_l, VGA_VS, VGA_HS, irq;
   logic [7:0] VGA_R, VGA_B, VGA_G;
   logic       clk_rst;
   
   
   centipede cent(.CLOCK_50(clk), .KEY({clk_rst, 1'b1, irq, rst_l}), 
		  .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B),
		  .VGA_HS(VGA_HS), .VGA_VS(VGA_VS));

   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end

   initial begin
      irq = 1'b0;
      rst_l = 1'b0;
      clk_rst = 1'b0;
      @(posedge clk);
      @(posedge clk);
      clk_rst = 1'b1;
      repeat(100) begin
	 @(posedge clk);
	 @(posedge clk);
      end
       rst_l = 1'b1;

      repeat(1000000) begin
	 @(posedge clk);
      end
      $finish;
   end
      
endmodule: test
`endif
