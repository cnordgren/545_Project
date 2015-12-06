`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2015 05:08:14 PM
// Design Name: 
// Module Name: LS245
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


module LS245(inout logic [7:0] A, B,
            input logic dir, en_l);
            
            always_comb begin
                if(en_l == 1'b1) begin
                    A = 8'bzzzz_zzzz;
                    B = 8'bzzzz_zzzz;
                end
                else begin
                    if(dir)
                        B = A;
                    else
                        A = B;
                end
            end
endmodule
