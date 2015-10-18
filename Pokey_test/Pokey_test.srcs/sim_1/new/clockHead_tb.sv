//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2015 04:47:39 PM
// Design Name: 
// Module Name: clockHead_tb
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


module clockHead_tb();
    logic inClk, outClk;
    
    clockHead ckh(inClk, outClk);
    
    initial begin
        repeat(10000) inClk = ~inClk;
    
    end


endmodule
