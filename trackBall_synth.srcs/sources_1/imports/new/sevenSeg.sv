`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2015 05:37:40 PM
// Design Name: 
// Module Name: sevenSeg
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



module sevenSeg(input  logic [3:0] in,
                output logic segA, segB, segC, segD,
                             segE, segF, segG, segDP);
                             
     logic [7:0] SevenSeg;
     
     
     
  
     always_comb begin
             case(in)
              4'h0: SevenSeg = 8'b11111100;
              4'h1: SevenSeg = 8'b01100000;
              4'h2: SevenSeg = 8'b11011010;
              4'h3: SevenSeg = 8'b11110010;
              4'h4: SevenSeg = 8'b01100110;
              4'h5: SevenSeg = 8'b10110110;
              4'h6: SevenSeg = 8'b10111110;
              4'h7: SevenSeg = 8'b11100000;
              4'h8: SevenSeg = 8'b11111110;
              4'h9: SevenSeg = 8'b11110110;
              4'ha: SevenSeg = 8'b11101110;
              4'hb: SevenSeg = 8'b00111110;
              4'hc: SevenSeg = 8'b10011100;
              4'hd: SevenSeg = 8'b01111010;
              4'he: SevenSeg = 8'b10011110;
              4'hf: SevenSeg = 8'b10001110;
              default: SevenSeg = 8'b00000000;
             endcase
      end
      
       assign {segA, segB, segC, segD, segE, segF, segG, segDP} = ~SevenSeg;

 endmodule   
     /*
     logic [23:0] cnt;
     logic cntovf = &cnt;
     logic [3:0] BCD_new, BCD_old;
     logic [4:0] PWM;
     logic [3:0] PWM_input = cnt[22:19];
     logic [3:0] BCD = (cnt[23] | PWM[4]) ? BCD_new : BCD_old;
     logic [7:0] SevenSeg;
     
     always__ff @(posedge clk) begin 
         cnt <= cnt + 24'h1;
         if (cntovf) begin
             BCD_new <= (BCD_new == 4'h9 ? 4'h0 : BCD_new + 4'h1);
             BCD_old <= BCD_new;    
         end
         PWM <= PWM[3:0] + PWM_input;
     end
     

    
     always_comb begin
        case(BCD)
         4'h0: SevenSeg = 8'b11111100;
         4'h1: SevenSeg = 8'b01100000;
         4'h2: SevenSeg = 8'b11011010;
         4'h3: SevenSeg = 8'b11110010;
         4'h4: SevenSeg = 8'b01100110;
         4'h5: SevenSeg = 8'b10110110;
         4'h6: SevenSeg = 8'b10111110;
         4'h7: SevenSeg = 8'b11100000;
         4'h8: SevenSeg = 8'b11111110;
         4'h9: SevenSeg = 8'b11110110;
         default: SevenSeg = 8'b00000000;
        endcase
      end
     assign {segA, segB, segC, segD, segE, segF, segG, segDP} = SevenSeg;
     */
        

