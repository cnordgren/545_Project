`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2015 05:14:11 PM
// Design Name: 
// Module Name: test_mp
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


module test_mp();
    logic clk, rst, WRITE;
    logic [7:0] DI, DO;
    logic [15:0] AB;

   
    logic  [3:0] rom;
    logic  STEERCLR, WATCHDOG, OUT0;
    logic  IRQRES, POKEY, SWRD;
    logic  PF, RAM0, COLORRAM;
    logic  NinetyNine, EA_READ;
    logic  EA_CONTROL, EA_ABOR, INQ;
    logic  INI, PFRAMRD;
    logic  [3:0] PFWR;
    
    
     top   tp(.clk(clk), .rst(rst), .rom(rom), .STEERCLR(STEERCLR), .WATCHDOG(WATCHDOG), .OUT0(OUT0),
                 .IRQRES(IRQRES), .POKEY(POKEY), .SWRD(SWRD), .PF(PF), .RAM0(RAM0), .COLORRAM(COLORRAM),
                 .NinetyNine(NinetyNine), .EA_READ(EA_READ), .EA_CONTROL(EA_CONTROL), .EA_ABOR(EA_ABOR),
                 .INQ(INQ), .INI(INI), .PFRAMRD(PFRAMRD), .PFWR(PFWR));


     
     initial begin
     
        repeat(10000) #5 clk = ~clk;
     end
     
     initial begin
        #10 clk = 0;
            rst = 1;
         #50 rst = 0;
     end
     
endmodule
