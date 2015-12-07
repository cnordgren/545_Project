`define ALTERA

`ifdef ALTERA
module centipede(
		 
		 );
`else
module centipede(

		 );
   logic [15:0] addr;
   tri [7:0] 	data;
   logic 	cpu_we_l;
`endif

   cpu sixty502(.clk(), .reset(), .AB(addr), .DI(data), .DO(), .WE(cpu_we_l), .IRQ(), 
		.NMI(1'b1), .RDY(1'b1));

   cpuRam ram();

   cpuRom rom();
   
   graphicsPipeline gp(.clk(clk), .addr(addr), .data_in(data), .data_out(), .rst_l(),
		       .VGA_R(), .VGA_B(), VGA_G(), .VGA_HS(), .VGA_VS(), 
		       .VGA_BLANK_N(), .VGA_CLK(), .VGA_SYNC_N());

   // Address decoder FIX ME I NEED HELP
   address_decoder ad(.AB(addr), .WRITE(cpu_we_l), .BR_W(), .GMHZ());

   POKEY pokey(.Din(data), .Dout(), .A(addr[3:0]), .P(8'hF), .phi2(),
	       .readHighWriteLow(cpu_we_l), .cs0Bar(pokey_en_l), .aud(), .clk(clk));
   
   input_network in(.joy1(4'd0), .joy2(4'd0), .ops1(), .ops2(), .readops_l(),
		    .coinR(1'b0), .coinL(1'b0), .coinC(1'b0), .vblank(),
		    .start1(), .start2(1'b0), .fire1(), .fire2(1'b0), .readbut_l(),
		    .seltri(addr[0]),
		    .hordir1(), .horclk1(), .verdir1(), .verclk1(),
		    .hordir2(1'b0), .horclk2(1'b0), .verdir2(1'b0), .verclk2(1'b0),
		    .trackrst_l(), .steerclr(), .ballselect(),
		    .data_out());

   
   

endmodule: centipede
