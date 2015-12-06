`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2015 02:59:59 PM
// Design Name: 
// Module Name: top_pc2led
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


module top_pc2led(input logic clk,
                  input logic [15:0] PC,
                  output logic [6:0] seg,
                  output logic [7:0] an
    );
    
    logic [15:0] counter = 0;
    logic [3:0] decimalValue, A0, A1, A2, A3, A4;
    logic [2:0] curr_state, next_state;
    logic       temp;
          
          
    always_ff @(posedge clk) begin
        counter <= counter + 1; 
    end
    
    // assign state to next state on clock      
    always_ff @(posedge counter[12]) begin
        curr_state <= next_state;
    end
        
    // increment state in constant loop
    always_comb begin
        if(curr_state == 3'd3)
            next_state = 3'd0;
        else
            next_state = curr_state + 3'd1;
    end
       
    // convert PC to decimal degits
    //BCD   bcd(.PC(PC), .A0(A0), .A1(A1), .A2(A2), .A3(A3), .A4(A4));
    always_comb begin
        A0 = PC[3:0];
        A1 = PC[7:4];
        A2 = PC[11:8];
        A3 = PC[15:12];
    end
    
    
    // cycle through decimals value to display
    always_comb begin
        case(curr_state) 
            3'd0    :   decimalValue = A0;
            3'd1    :   decimalValue = A1;
            3'd2    :   decimalValue = A2;
            3'd3    :   decimalValue = A3;
            //3'd4    :   decimalValue = A4;
            default :   decimalValue = 4'b0;
        endcase
     end

    // output correct seven segment binary code based on decimal outputting
    sevenSeg  ss(.in(decimalValue), .segA(seg[0]), .segB(seg[1]), .segC(seg[2]), .segD(seg[3]), .segE(seg[4]), .segF(seg[5]),
                .segG(seg[6]), .segDP(temp));
                
    // cycle through correct decimal place to display
    always_comb begin
        case(curr_state) 
            3'd0    :   an = 8'b11111110;
            3'd1    :   an = 8'b11111101;
            3'd2    :   an = 8'b11111011;
            3'd3    :   an = 8'b11110111;
            //3'd4    :   an = 8'b11101111;
            default :   an = 8'b11111111;
        endcase
     end         
    
endmodule
