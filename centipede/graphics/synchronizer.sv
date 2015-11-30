`define SIM

module synchronizer(input logic        clk_12096,
		    input logic        global_rst,
		    output logic [8:0] hcount,
		    output logic [7:0] vcount,
		    output logic       clk_6_l,
		    output logic       vblank, vblank_l, vblankd_l,
		    output logic       vsync, vsync_l,
		    output logic       hsync, hsync_l,
		    output logic       R256H2D_l, R256HD, R256HD_l, R256H_l,
		    output logic       R4H_l, pload_l,
		    output logic       hblank_l,
		    output logic       mob_l,
		    output logic       vreset_l);

   logic        clk_6;
   logic [11:0] hraw;
   logic 	hsync_inter;

   counter #(12) colcnt(.D(12'hB00), .Q(hraw), .clk(clk_12096), .rst_l(global_rst), 
			.en(1'b1), .load((hraw[11:8] == 4'hF)));

   assign clk_6 = hraw[0];
   assign clk_6_l = ~clk_6;
   
   assign hcount = hraw[9:1];
   assign R256H_l = ~hraw[9];
   assign R4H_l = ~hcount[2];

   assign pload_l = ~(hcount[0] & hcount[1] & hcount[2]);
   assign mob_l = (~(R256H_l & R256HD) & ~(R256HD & R256H2D_l));
 
   counter #(8) rowcnt(.D(8'd0), .Q(vcount), .clk(R256H_l), .rst_l(global_rst),
		       .en(1'b1), .load(~vreset_l));


   // HSYNC generator M3
   ls74 m3_1(.D(hcount[7]), .Q(), .Q_l(hsync_inter), .clk(hcount[6]), .rst_l(1'b1), .pre_l(R256H_l));
   ls74 m3_2(.D(hcount[6]), .Q(hsync), .Q_l(hsync_l), .clk(hcount[4]), .rst_l(hsync_inter), .pre_l(1'b1));

   logic 	nc1, nc2, nc3, nc4;

   // Signal Output Bufer M4	   
   ls175 m4(.D({R256HD, hraw[9], vblank_l, 1'b0}), 
	    .Q({nc1, R256HD, vblankd_l, nc2}), .Q_l({R256H2D_l, R256HD_l, nc3, nc4}),
	    .clk(&({~clk_12096, hraw[3:0]})), .rst_l(global_rst));

   // VSYNC, VBLANK, and VRESET lookup table
   logic [3:0]	vsyncl_raw;
   logic [2:0]	vsnc; // vsync no connect

   vsyncLookup p4(.A({vblank, vcount[7:5], vcount[3:0]}), .D(vsyncl_raw));
   ls175 n4(.D(vsyncl_raw), 
	    .Q({vblank, vsnc[2:1], vsync}), .Q_l({vblank_l, vreset_l, vsnc[0], vsync_l}),
	    .clk(R256H_l), .rst_l(global_rst));

   // HBLANK generator logic
   logic 	coloren;
   logic 	hblank_inter_1, hblank_inter_2;
   
   ls74 d4(.D(coloren), .Q(), .Q_l(hblank_inter_1), .clk(~(clk_12096 & clk_6)),
	   .pre_l(1'b1), .rst_l(global_rst));
   ls107 l4(.J(R256HD), .K(R256HD_l), .clk(clk_6), .rst_l(global_rst), 
	    .Q(coloren), .Q_l(hblank_inter_2));
   assign hblank_l = ~(hblank_inter_2 & hblank_inter_1);
   
endmodule: synchronizer


// This module replicates the combinational PROM LUT used
// to generate the vsync, vblank and vreset signals, chip P4
module vsyncLookup(input logic [7:0] A,
		   output logic [3:0] D);
   
   always_comb begin
      if(A >= 8'h68 && A <= 8'h7E)
	D = 4'h2;
      else if(A >= 8'h7F && A <= 8'h84)
	D = 4'hA;
      else if(A == 8'h85)
	D = 4'hE;
      else if(A >= 8'hE0 && A <= 8'hF1)
	D = 4'hA;
      else if(A >= 8'hF2 && A <= 8'hF4)
	D = 4'hB;
      else if(A >= 8'hF5 && A <= 8'hFF)
	D = 4'hA;
      else
	D = 4'h0;
   end // always_comb	             
   
endmodule: vsyncLookup
	    
// Note this is only 1 wide, actual chip had two FFs in one package
module ls74(input logic  D, 
	    input logic  clk, rst_l, pre_l,
	    output logic Q, Q_l);

   always_ff@(posedge clk, negedge rst_l, negedge pre_l)
     if(~pre_l & ~rst_l) begin
	Q <= 1'b1;
	Q_l <= 1'b1;
     end
     else if(~pre_l) begin
	Q <= 1'b1;
	Q_l <= 1'b0;
     end
     else if(~rst_l) begin
	Q <= 1'b0;
	Q_l <= 1'b1;
     end
     else begin
	Q <= D;
	Q_l <= ~D;
     end
   
endmodule: ls74

module ls107(input logic J, K, clk, rst_l,
	     output logic Q, Q_l);

   always_ff@(negedge clk, negedge rst_l) begin
      if(~rst_l) begin
	 Q <= 1'b0;
	 Q_l <= 1'b1;
      end
      else begin
	 if(~J & ~K) begin
	    Q <= Q;
	    Q_l <= Q_l;
	 end
	 else if(J & ~K) begin
	    Q <= 1'b1;
	    Q_l <= 1'b0;
	 end
	 else if(~J & K) begin
	    Q <= 1'b0;
	    Q_l <= 1'b1;
	 end
	 else if(J & K) begin
	    Q <= ~Q;
	    Q_l <= ~Q_l;
	 end
      end
   end

endmodule: ls107

module ls175(input logic [3:0] D,
	     output logic [3:0] Q, Q_l,
	     input logic 	clk, rst_l);

   always_ff@(posedge clk, negedge rst_l) begin
      if(~rst_l) begin
	 Q <= 4'd0;
	 Q_l <= 4'b1111;
      end
      else begin
	 Q <= D;
	 Q_l <= ~D;
      end
   end

endmodule: ls175



module counter
  #(parameter WIDTH=8)
   (input logic clk, rst_l, en, load,
    input logic [WIDTH-1:0]  D,
    output logic [WIDTH-1:0] Q);

   logic [WIDTH-1:0] count;

   always_ff @(posedge clk, negedge rst_l)
     if(~rst_l)
       count = 0;
     else if(load)
       count <= D;
     else if(en)
       count <= count+1;
     else
       count <= count;

   assign Q = count;
   
endmodule: counter

    
`ifdef SIM
module simtop();
   logic       clk, global_rst;
   logic [8:0] hcount;
   logic [7:0] vcount;
   logic       clk_6_l;
   logic       vblank, vblank_l, vblankd_l;
   logic       vsync, vsync_l;
   logic       hsync, hsync_l;
   logic       R256H2D_l, R256HD, R256HD_l, R256H_l;
   logic       R4H_l, pload_l;
   logic       hblank_l;
   logic       mob_l;
   logic       vreset_l;

   synchronizer s(.clk_12096(clk), .*);
   
   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end

   initial begin
      int i;
      global_rst = 1'b0;
      #10;
      global_rst = 1'b1;
      for(i=0; i < 403200; i++) begin
	 @(posedge clk);
      end
      $finish;
   end
   
endmodule: simtop

`endif
