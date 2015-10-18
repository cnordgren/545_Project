`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2015 06:33:12 PM
// Design Name: 
// Module Name: pokeyaudio_tb
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


module pokeyaudio_tb();
    logic init_L, clk179, clk64, clk16, STIMER_strobe;
    logic audio1, audio2, audio3, audio4;
    logic int1, int2, int4;
    logic [3:0] vol1, vol2, vol3, vol4;
    logic [7:0] AUDF1, AUDF2, AUDF3, AUDF4;
    logic [7:0] AUDC1, AUDC2, AUDC3, AUDC4, AUDCTL;
    logic [7:0] RANDOM;
    
    pokeyaudio   pa(init_L, clk179, clk64, clk16, STIMER_strobe,
                    AUDF1, AUDF2, AUDF3, AUDF4,
                    AUDC1, AUDC2, AUDC3, AUDC4, AUDCTL, 
                    audio1, audio2, audio3, audio4,
                    vol1, vol2, vol3, vol4,
                    RANDOM, int1, int2, int4);




endmodule
