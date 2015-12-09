module address_decoder(input logic [15:0] addr,
		       input logic  we_l,
		       // Chip selects for I/O
		       output logic swrd_l,
		       output logic steerclr_l,
		       output logic in0_l, in1_l,
		       output logic tb_flip,
		       // Chip selects for graphics
		       output logic pfram_l,
		       // Chip select for pokey
		       output logic pokey_l,
		       // Chip select for CPU ROM/RAM
		       output logic rom_l, ram_l,
		       output logic irq_l);

   always_comb begin
      swrd_l = 1'b1;
      steerclr_l = 1'b1;
      in0_l = 1'b1;
      in1_l = 1'b1;
      tb_flip = 1'b0;
      pfram_l = 1'b1;
      pokey_l = 1'b1;
      rom_l = 1'b1;
      ram_l = 1'b1;
      irq_l = 1'b1;
      
      // CPU RAM
      if(addr <= 16'h03FF) begin
	 ram_l = 1'b0;
      end
      // Playfield RAM
      else if(addr >= 16'h0400 && addr <= 16'h07FF) begin
	 pfram_l = 1'b0;
      end
      // Option Switches
      else if(addr == 16'h0800 || addr == 16'h0801) begin
	 swrd_l = 1'b0;
      end
      // Trackball Stuff
      else if(addr == 16'h0C00 || addr == 16'h0C01) begin
	 in0_l = 1'b0;
      end
      else if(addr == 16'h0C02 || addr == 16'h0C03) begin
	 in1_l = 1'b0;
      end
      // Pokey
      else if(addr >= 16'h1000 && addr <= 16'h100F) begin
	 pokey_l = 1'b0;
      end
      
      // High score NVRAM not implemented

      // IRQ ACK
      else if(addr == 16'h1800) begin
	 irq_l = 1'b0;
      end
      
      // Coin counter registers not implemented

      // Trackball Flip
      else if(addr == 16'h1C07) begin
	 tb_flip = 1'b1;
      end

      // Watchdog not implemented

      // Trackball counter clear
      else if(addr == 16'h2400) begin
	 steerclr_l = 1'b0;
      end

      // ROM
      else if(addr >= 16'h2000) begin
	 rom_l = 1'b0;
      end
   end // always_comb
endmodule: address_decoder

/*	
module address_decoder(input  logic  [15:0] AB, 
                       input  logic  WRITE, BR_W, 
                       input  logic  GMHZ, PAC,
                       output logic  ROM, WRITE_2,
                       output logic  [3:0] rom,
                       output logic  STEERCLR, WATCHDOG, OUT0,
                       output logic  IRQRES, POKEY, SWRD,
                       output logic  PF, RAM0, COLORRAM,
                       output logic  NinetyNine, EA_READ,
                       output logic  EA_CONTROL, EA_ABOR, IN0,
                       output logic  IN1, PFRAMRD,
                       output logic  [3:0] PFWR);
    
    logic [15:0] ls42_out;
    logic [3:0]  ls139m_out;
    logic        A8H2, C5P1, U550, L9UCB, OUA5, F733, L4231;
    logic        L3580, L4P5C, AOOH, F6HP, F97A, ls139_en;


    //output for ls42
    always_comb begin
        A8H2 = ~ls42_out[9];
        C5P1 = ~ls42_out[8];
        U550 = ~ls42_out[7];
        L9UCB = ~ls42_out[6];
        OUA5 = ~ls42_out[5];
        F733 = ~ls42_out[4];
        L4231 = ~ls42_out[3];
        L3580 = ~ls42_out[2];
        L4P5C = ~ls42_out[1];
        AOOH = ~ls42_out[0];

    end

    assign POKEY = F733;
    assign SWRD = L3580;
    assign PF = L4P5C;
    assign RAM0 = AOOH;
    //assign RAM0 = (~AB[13] & ~AB[12] & ~AB[11] & ~AB[10]);
    
    //output for ls139(middle chip in diagram)
    always_comb begin
        NinetyNine = ls139m_out[3];
        EA_READ = ls139m_out[2];
        EA_CONTROL = ls139m_out[1];
        EA_ABOR = ls139m_out[0];
    end

     assign ROM = ~AB[13];
    //assign ROM = (BR_W | (~AB[13]));
    //assign ROM = (~RAM0 & (BR_W | (~AB[13])));
    //assign ROM =  ~((~BR_W) & AB[13]);
    assign WRITE_2 = ~(GMHZ & (~WRITE));
    assign STEERCLR = (WRITE_2 | A8H2);
    assign WATCHDOG = (WRITE_2 | C5P1);
    assign OUT0 = (WRITE_2 | U550);
    assign IRQRES = (WRITE_2 | L9UCB);

    assign F6HP = (AB[9] | OUA5);
    assign F97A = (OUA5 | (~AB[9]));
    assign COLORRAM = (F6HP | PAC); 

    assign IN0 = (L4231 | AB[1]);
    assign IN1 = (L4231 | (~AB[1]));
    assign PFRAMRD = (BR_W | L4P5C);
    assign ls139_en = (WRITE | L4P5C);

    decoder_oneCold  #(4) LS42(.sel(AB[13:10]), .en(1'b1), .out(ls42_out));

    decoder_oneCold  #(2) LS139T(.sel(AB[12:11]), .en(~ROM), .out(rom));

    decoder_oneCold  #(2) LS139M(.sel(AB[8:7]), .en(~F97A), .out(ls139m_out));

    decoder_oneCold  #(2) LS139B(.sel(AB[5:4]), .en(~ls139_en), .out(PFWR));


endmodule

*/
