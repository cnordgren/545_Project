module top
    (input logic clk, btnC,
    output logic JA[3:0]);
    
    logic MCK, SCK, WS, SD, rst_l;
    logic [4:0] sck_out;
    logic [2:0] ws_out;
    logic [17:0] addr;
    logic [15:0] data_r, data_l;
    
    
    assign rst_l = ~btnC;
    assign JA[0] = MCK;
    assign JA[1] = WS;
    assign JA[2] = SCK;
    assign JA[3] = SD;
    assign data_l = data_r;
    
    I2S_interface myInterface(.WS(WS), .SCK(SCK), .rst_l(rst_l), .SD(SD),
                              .left_data(data_l), .right_data(data_r));
    
    blk_mem_gen_0 bm(.clka(SCK), .addra(addr), .douta(data_r));

    counter #(18) cnt(.clk(WS), .count(addr), .rst_l(rst_l));
    
    clk_wiz_0 clkgen(.clk_in(clk), .clk_out(MCK), .resetn(rst_l));
    
    counter #(5) cnt2(.clk(MCK), .count(sck_out), .rst_l(rst_l));
    
    counter #(3) cnt3(.clk(SCK), .count(ws_out), .rst_l(rst_l));
    
    assign WS = ws_out[2];
    
    assign SCK = sck_out[4];
    
endmodule: top 
//testing d flip flop
/*
module test_dff();
    logic   SCK, WS, SD, rst_l;
    logic   [23:0] data_l, data_r, word;
    logic [14:0] addr;
 
    I2S_interface myInterface(.WS(WS), .SCK(SCK), .rst_l(rst_l), .SD(SD),
                              .left_data(data_l), .right_data(data_r));
                              
     blk_mem_gen_0 bm(.clka(SCK), .addra(addr), .douta(data_r));

     counter #(15) cnt(.clk(SCK), .count(addr), .rst_l(rst_l));
     
     sipo #(24) s1(.d(SD), .clk(SCK), .rst_l(rst_l), .out(word));
     
     assign data_l = data_r;
     
     initial begin
        forever #5 SCK = ~SCK;
     end
     
     initial begin
        SCK = 0;
        WS = 0;
        rst_l = 0;
        #18 rst_l = 1;
        #1 WS = 1;
        #240 WS = 0;
        #240;
        $finish;
     end
     
     
     
     
     
//   logic d, clk, rst, q;

//   dff    df0(d, clk, rst, q);

//   initial begin 
//      clk = 0;
//      rst = 1;
//      d = 0;
//      forever #5 clk = ~clk;
//   end
   
//   initial begin   
//      #10 rst = 0;
//      #8 rst = 1;
//      #2 d = 1;
//      #100 $display("d=%b, q=%b", d, q);
//      $finish;
//   end
endmodule
*/

module sipo
    #(parameter WIDTH=8)
    (input logic clk, rst_l, d,
    output logic [WIDTH-1:0] out);
    
    always_ff @(posedge clk, negedge rst_l) begin
        if(~rst_l)
            out <= 'd0;
        else
            out <= {(out << 1) & ~'d1 | d};
    end
    
endmodule: sipo

module counter
    #(parameter WIDTH=8)
    (input logic clk, rst_l,
     output logic [WIDTH-1:0] count);
     
     always_ff@(posedge clk, negedge rst_l) begin
        if(~rst_l)
            count <= 'd0;
        else
            count <= count + 1;
     end

endmodule: counter
