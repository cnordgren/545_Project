module top(input logic clk,
           input logic btnU,
           input logic sw[15:0],
           output logic [6:0] seg,
           output logic [7:0] an,
           output logic [15:0] led);
           
           
  
    logic [15:0] SBA;
    logic [7:0] dataIn;
    logic [7:0] dataOut;
    logic [7:0] romOut, ramOut;
    tri [7:0] dataBus;
    logic [15:0] PC;
    logic button;
    
    //logic sndnmi;
    logic sndirq;
    logic RW_l;
    logic ena;
    logic rst_l;
    logic WRITE;
    //logic BR_W;
    //logic ROM, RAM0;
    
    logic BR_W, GMHZ, PAC, ROM, WRITE_2;
    logic STEERCLR, WATCHDOG, OUT0, IRQRES, POKEY;
    logic SWRD, PF, RAM0, COLORRAM, NinetyNine, EA_READ;
    logic EA_CONTROL, EA_ABOR, INQ, INI, PFRAMRD;
    logic [3:0] rom, PFWR;
    
    assign WRITE = ~(BR_W & 1'b1);
    assign BR_W = ~RW_l;
    
    assign rst_l = sw[0];
    //assign RW_l = 1'b0;
    assign sndirq = 0;
    //assign sndnmi = 0;
    assign button = btnU;
//    assign BR_W = ~RW_l;
//    assign GMHZ = 1'b0;
//    assign PAC = 1'b0;
    
    //cpu my6502(.clk(button), .reset(rst_l), .NMI(1'b1), .IRQ(sndirq), .RDY(1'b1),
                                    //.AB(SBA), .WE(RW_l), .DI(SD), .DO(SD1), .PC(PC));
                                    
    microprocessor   my6502(.clk(button), .rst(rst_l), .IRQRES(sndirq), .DI(dataIn), .R_W(RW_l), .DO(dataOut), .AB(SBA));
    assign dataBus = (POKEY) ? dataOut : 8'bzzzz_zzzz;
    
    top_pc2led  tpc(.clk(clk), .PC({2'b0, SBA[13:0]}), .seg(seg), .an(an));
                
    address_decoder  ad(.AB(SBA), .WRITE(WRITE), .BR_W(BR_W), .GMHZ(GMHZ), .PAC(PAC), .ROM(ROM), .WRITE_2(WRITE_2), .rom(rom), .STEERCLR(STEERCLR), 
                              .WATCHDOG(WATCHDOG), .OUT0(OUT0), .IRQRES(IRQRES), .POKEY(POKEY), .SWRD(SWRD), .PF(PF), .RAM0(RAM0), .COLORRAM(COLORRAM), .NinetyNine(NinetyNine), .EA_READ(EA_READ),
                              .EA_CONTROL(EA_CONTROL), .EA_ABOR(EA_ABOR), .INQ(INQ), .INI(INI), .PFRAMRD(PFRAMRD), .PFWR(PFWR));
    
    //address_decoder_wrapper  adw(.AB(SBA), .WRITE(WRITE), .BR_W(BR_W), .ROM(ROM), .RAM0(RAM0));
    
    assign led[0] = ~ROM;
    assign led[1] = ~RAM0;
    assign led[2] = RW_l;
    assign led[15:3] = 13'b0;
    
    /*always_comb begin
       if (ROM == 1'b1) begin
          led[0] = ROM;
          led[1] = ~ROM;
       end
       else if (RAM0 == 1'b1) begin
          led[1] = RAM0;
          led[0] = ~RAM0;
        end
    
    end*/
                                                            
    //assign ena = SBA[15] | SBA[14];
    
 
    
    Cent_ROM  r0m(.addra(SBA[13:0]-14'h2000), .clka(clk), .douta(romOut), .ena(ROM));
    assign dataBus = (ROM) ? romOut : 8'bzzzz_zzzz;
    
    Centipede_RAM ram(.addra(SBA[9:0]), .clka(clk), .dina(SD), .ena(RAM0), .wea(RW_l), .addrb(SBA[9:0]), .clkb(clk), .doutb(ramOut), .enb(RAM0));
    assign dataBus = (RW_l) ? ramOut : 8'bzzzz_zzzz;
  
    
endmodule
