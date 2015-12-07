module top_trackBall(
                 input logic [15:0] sw,
                 input logic [7:0] JA,
                 input logic clk,
                 output logic [15:0] led,
                 output logic [6:0] seg,
                 output logic [7:0] an);
     logic [1:0] inp1;
     logic [1:0] inp2;
     logic [1:0] inp3;
     logic [1:0] inp4;
     logic [3:0] tra; 
     logic [3:0] trb; 
     logic [3:0] decimalValue;
     logic [7:0] newAn;
     logic deadwire;
     
     always_ff @(posedge clk) begin
        an <= newAn;
     end
     
     always_comb begin
        if(an == 8'b1111_1110) begin
            decimalValue = tra;
            newAn = 8'b1111_1101;
        end
        else begin
            decimalValue = trb;
            newAn = 8'b1111_1110;
        end
     end
     
     assign led[15:2] = 14'd0;
     
     assign inp1 = {JA[0], 1'b0};
     assign inp2 = {JA[1], 1'b0};
     assign inp3 = {JA[2], 1'b0};
     assign inp4 = {JA[3], 1'b0};
     
     
     //trackball tb(.hordir({sw[0], 1'b0}), .horclk({sw[1], 1'b0}), .verdir({sw[2], 1'b0}), .verclk({sw[3], 1'b0}), .rstclr_l(sw[4]), .steerclr(sw[5]), .flip(1'b1), .dir1(led[0]), .dir2(led[1]), .tra(tra), .trb(trb));
    //trackball tb(.hordir(inp1), .horclk(inp2), .verdir(inp3), .verclk(inp4), .rstclr_l(sw[4]), .steerclr(sw[5]), .flip(1'b1), .dir1(led[0]), .dir2(led[1]), .tra(tra), .trb(trb));
    trackball tb(.hordir(inp1), .horclk(inp2), .verdir(inp3), .verclk(inp4), .rstclr_l(sw[14]), .steerclr(sw[15]), .flip(sw[0]), .dir1(led[0]), .dir2(led[1]), .tra(tra), .trb(trb));

     sevenSeg   ss0(.in(decimalValue), .segA(seg[0]), .segB(seg[1]), .segC(seg[2]), .segD(seg[3]), .segE(seg[4]), .segF(seg[5]), .segG(seg[6]), .segDP(deadwire));

endmodule

