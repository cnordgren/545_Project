`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2015 04:39:05 PM
// Design Name: 
// Module Name: poly4bit_tb
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


module poly4bit_tb();
    logic clk, init_L, out;
    
    poly4bit   p4b(clk, init_L, out);

    initial begin
       //forever #5 clk = ~clk;
       repeat(10000)  #5 clk = ~clk;
    end

    initial begin
       clk = 0;
       init_L = 1'b0;
       #10 init_L = 1'b1;
       
    end
endmodule
