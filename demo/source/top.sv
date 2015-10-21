
module top();
   logic [7:0]	SD;
   logic [13:0] SBA;
   logic [1:0]	top_address_bits;
   logic 	rst_l; 
   logic 	clock_15;
   logic 	sndirq, sndnmi;
   logic 	audio_out;
   logic 	pokey_sel;
   logic 	RW_l, WR_l;
   logic	MXT;
   logic [13:0]	SBA;
   logic [7:0]	SBD;
   logic [7:0]	SMD;
   logic	tri_en;

   assign WR_l = ~RW_l;

   
   //Block RAM for system memory
   
   
   //Block ROM for program memory
   
   
   //6502 Processor Instantiation
	cpu my6502(.clk(clock_15), reset(rst_l), .NMI(sndnmi), .IRQ(sndirq), .RDY(1'b1),
			.AB({top_address_bits, SBA}), .WE(RW_l),  .DI(SD), .DO(SD));

	assign tri_en = MXT | SBA[6];
	tristate t1(.left(SD), .right(SBD), .switch(RW_l), .en(tri_en));
	tristate t2(.left(SD), .right(SMD), .switch(RW_l), .en(~MXT));
   
   
   //Pokey Audio Synthesis Chip
   
   
   //PWM Audio output interface
   
   
   
endmodule: top
