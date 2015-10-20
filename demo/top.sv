
module top();
   logic [7:0] data;
   logic [15:0] addr;
   logic 	rst_l; 
   logic 	clock_15;
   logic 	sndirq, sndnmi;
   logic 	audio_out;
   logic 	pokey_sel;
   logic 	RW_l, WR_l;

   assign WR_l = ~RW_l;
   
   //Block RAM for system memory
   
   
   //Block ROM for program memory
   
   
   //6502 Processor Instantiation
   
   
   //Pokey Audio Synthesis Chip
   
   
   //PWM Audio output interface
   
   
   
endmodule: top
