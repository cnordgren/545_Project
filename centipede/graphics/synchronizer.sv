module synchronizer(input logic        clk_12096, vreset_l,
		    output logic [8:0] hcount,
		    output logic [7:0] vcount,
		    output logic       clk_6_l,
		    output logic       vblank, vblank_l, vblankd_l,
		    output logic       vsync, vsync_l,
		    output logic       hsync, hsync_l,
		    output logic       256H2D_l, 256HD, 256HD_l, 256H_l,
		    output logic       4H_l, pload_l,
		    output logic       hblank_n);

   logic clk_6;
   logic [11:0] hraw;

   counter #(12) colcnt(.D(12'h00D), .Q(hraw), .clk(clk_12096), .rst_l(vreset_l), 
			.en(1'b1), .ld(hraw == 12'hFFF));

   assign clk_6 = hraw[0];
   assign clk_6_l = ~clk_6;
   
   assign hcount = hraw[8:1];
   assign 256H_l = ~hraw[8];
   assign 4H_l = ~hcount[2];
 
   counter #(8) rowcnt(.D(8'd0), .Q(vcount), .clk(~hraw[11]), .rst_l(vreset_l),
		       .en(1'b1), .ld(1'b0));
   
   
   
endmodule: synchronizer

module reg_2out
  #(parameter WIDTH=1)
   (input logic clk, rst_l, prst_l, 
    input logic [WIDTH-1:0] D,
    output logic [WIDTH-1:0] Q, Q_l);


   always_ff@(posedge clk)
     if(
   
endmodule: reg_2out


module counter
  #(parameter WIDTH=8)
   (input logic clk, rst_l, en, load,
    input logic [WIDTH-1:0]  D,
    output logic [WIDTH-1:0] Q);

   logic [WIDTH-1:0] count;

   always_ff @(posedge clk, negedge rst_l)
     if(~rst_l)
       count = WIDTH'0;
     else if(load)
       count <= D;
     else if(en)
       count <= count+1;
     else
       count <= count;

   assign Q = count;
   
endmodule: counter

    
