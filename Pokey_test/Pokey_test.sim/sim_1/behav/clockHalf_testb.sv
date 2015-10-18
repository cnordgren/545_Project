`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2015 05:09:06 PM
// Design Name: 
// Module Name: clockHalf_testb
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


module clockHalf_tb();
    logic inClk, outClk;
    
    clockHalf ckh(inClk, outClk);
    
    initial begin
        repeat(10000) #5 inClk = ~inClk;
    
    end
    initial inClk = 0;

endmodule


