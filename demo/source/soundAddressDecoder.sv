`include "../../library/lib.sv"


module soundAddressDecoder(input logic addr[15:0],
			   input logic 	RD02, WR02,
			   output logic SROM0_l, SROM1_l, SROM2_l,
			   output logic SRAM0_l, SRAM1_l,
			   output logic SNDEXT_l, MXT, CSND_l, YMHCS_l,
			   output logic SIOWR_l, WR68k_l, SIORD_l, RD68k_l);

   logic dec19m1_out[3:0];
   logic dec19m2_out[3:0];
   logic dec18j_out[7:0];

   
   decoder #(2) ic19M1(.sel(addr[15:14]), .en(1), .out(dec19m1_out));
   assign {SROM2_l, SROM1_l, SROM0_l} = dec19m1_out[3:1];
   
   decoder #(2) ic19M2(.sel(addr[13:12]), .en(dec19m1_out), .out(dec19m2_out));
   assign {MXT, SNDEXT_l, SRAM1_l, SRAM0_l} = dec19m2_out;
   
   decoder #(3) ic18J(.sel(addr[6:4]), .en(1), .out(dec18j_out));
   assign CSND_l = dec18j_out[7];
   assign YMHCS_l = dec18j_out[0];

   assign SIOWR_l = WR02 | dec18j_out[2];
   assign WR68k_l = WR02 | dec18j_out[1];
   assign SIORD_l = RD02 | dec18j_out[2];
   assign RD68k_l = RD02 | dec18j_out[1];      

endmodule: soundAddressDecoder

