
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
