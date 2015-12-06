`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2015 05:07:49 PM
// Design Name: 
// Module Name: address_decoder_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// S
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module address_decoder_wrapper(input logic [15:0] AB,
                               input logic WRITE,
                               input logic BR_W,
                               output logic ROM, RAM0 );


    logic GMHZ, PAC, ROM, WRITE_2;
    logic STEERCLR, WATCHDOG, OUT0, IRQRES, POKEY;
    logic SWRD, PF, RAM0, COLORRAM, NinetyNine, EA_READ;
    logic EA_CONTROL, EA_ABOR, INQ, INI, PFRAMRD;
    logic [3:0] rom, PFWR;
    
    //assign BR_W = WRITE;
    assign GMHZ = 1'b0;
    assign PAC = 1'b0;
    
    
    address_decoder  ad(.AB(AB), .WRITE(WRITE), .BR_W(BR_W), .GMHZ(GMHZ), .PAC(PAC), .ROM(ROM), .WRITE_2(WRITE_2), .rom(rom), .STEERCLR(STEERCLR), 
                              .WATCHDOG(WATCHDOG), .OUT0(OUT0), .IRQRES(IRQRES), .POKEY(POKEY), .SWRD(SWRD), .PF(PF), .RAM0(RAM0), .COLORRAM(COLORRAM), .NinetyNine(NinetyNine), .EA_READ(EA_READ),
                              .EA_CONTROL(EA_CONTROL), .EA_ABOR(EA_ABOR), .INQ(INQ), .INI(INI), .PFRAMRD(PFRAMRD), .PFWR(PFWR));
    
                




endmodule
