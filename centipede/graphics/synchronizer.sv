module synchronizer(input logic        clk_12096, vreset_l,
		    output logic [8:0] hcount,
		    output logic [7:0] vcount,
		    output logic       clk_6_n
		    output logic       vblank, vblank_n, vblankd_n,
		    output logic       vsync, vsync_n,
		    output logic       hsync, hsync_n,
		    output logic       256H2D_n, 256HD, 256HD_n,
		    output logic       4H_l, pload_l,
		    output logic       hblank_n);

   logic clk_6;
   logic [11:0] hraw;
   
   assign clk_6_n = ~clk_6;
   assign 4H_l = ~hcount[2];

   counter #(12) rowcnt(.D(12'h00D), .Q(hraw), .clk(clk_12096), .rst_l(
   

endmodule: synchronizer

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

    
