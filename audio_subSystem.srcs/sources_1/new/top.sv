`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2015 05:18:33 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input logic clk, rst,
    //input logic [7:0] DI;
    //input logic [7:0] DO;


     output logic  [3:0] rom,
     output logic  STEERCLR, WATCHDOG, OUT0,
     output logic  POKEY, SWRD,
     output logic  PF, RAM0, COLORRAM,
     output logic  NinetyNine, EA_READ,
     output logic  EA_CONTROL, EA_ABOR, INQ,
     output logic  INI, PFRAMRD,
     output logic  [3:0] PFWR);
     
      logic  [15:0] AB;
      logic  WRITE, BR_W; 
      logic  GMHZ, PAC;
      logic  ROM, WRITE_2;
      logic  IRQRES;

     assign WRITE = clk & BR_W;
     assign IRQRES = 1'b0;


     microprocessor   mp(.clk(clk), .rst(rst), .IRQRES(IRQRES), .DI(DI), .R_W(), .DO(DO), .AB(AB) );
     address_decoder  ad(.AB(AB), .WRITE(WRITE), .BR_W(BR_W), .GMHZ(GMHZ), .PAC(PAC), .ROM(ROM), .WRITE_2(WRITE_2), .rom(rom), .STEERCLR(STEERCLR), 
                          .WATCHDOG(WATCHDOG), .OUT0(OUT0), .IRQRES(IRQRES), .POKEY(POKEY), .SWRD(SWRD), .PF(PF), .RAM0(RAM0), .COLORRAM(COLORRAM), .NinetyNine(NinetyNine), .EA_READ(EA_READ),
                          .EA_CONTROL(EA_CONTROL), .EA_ABOR(EA_ABOR), .INQ(INQ), .INI(INI), .PFRAMRD(PFRAMRD), .PFWR(PFWR));
                          
 
                            



endmodule
