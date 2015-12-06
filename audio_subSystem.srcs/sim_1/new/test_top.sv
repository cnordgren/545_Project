`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2015 04:57:23 PM
// Design Name: 
// Module Name: test_top
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


 
module test_top();
     logic clk;
     logic btnU;
     logic sw[15:0];
     logic [6:0] seg;
     logic [7:0] an;
     logic [15:0] led;
     
    top     tp(.*);

    initial begin
       clk = 0;
       repeat(10000) #5 clk = ~clk;
    end
    
    


endmodule
