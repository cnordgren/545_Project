`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2015 06:03:14 PM
// Design Name: 
// Module Name: divideByN_tb
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





module divideByN_tb();
    logic strobe, in, def, out ,interrupt;
    logic [7:0] N;
    
    divideByN  dbn(strobe, N, in, def, out, interrupt);
    
    initial begin
       repeat (10000) #5 in = ~in;
    end
    
    initial begin
            def = 1;
            in = 0;
        //#10 N = 8'd2;
            strobe = 0;
            
         N = 8'd16;
         #200 strobe = 1;
         #20 strobe = 0;
        
    end
        



endmodule
