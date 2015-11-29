module synchronizer(input logic        clk_12096,
		    output logic [8:0] hcount,
		    output logic [7:0] vcount,
		    output logic       clk_6_l,
		    output logic       vblank, vblank_l, vblankd_l,
		    output logic       vsync, vsync_l,
		    output logic       hsync, hsync_l,
		    output logic       256H2D_l, 256HD, 256HD_l, 256H_l,
		    output logic       4H_l, pload_l,
		    output logic       hblank_l,
		    output logic       mob_l,
		    output logic       vreset_l);

   logic clk_6;
   logic [11:0] hraw;
   logic 	hsync_inter;

   counter #(12) colcnt(.D(12'h00D), .Q(hraw), .clk(clk_12096), .rst_l(vreset_l), 
			.en(1'b1), .ld(hraw == 12'hFFF));

   assign clk_6 = hraw[0];
   assign clk_6_l = ~clk_6;
   
   assign hcount = hraw[8:1];
   assign 256H_l = ~hraw[8];
   assign 4H_l = ~hcount[2];

   assign pload_l = ~(hcount[0] & hcount[1] & hcount[2]);
   assign mob_l = (~(256H_l & 256HD) & ~(256HD & 256H2D_l));
 
   counter #(8) rowcnt(.D(8'd0), .Q(vcount), .clk(256H_l), .rst_l(vreset_l),
		       .en(1'b1), .ld(1'b0));


   // HSYNC generator M3
   ls74 m3_1(.D(hcount[6]), .Q(), .Q_l(hsync_inter), .clk(hcount[5]), .rst_l(1'b1), .pre_l(256H_l));
   ls74 m3_2(.D(hcount[5]), .Q(hsync), .Q_l(hsync_l), .clk(hcount[3]), .rst_l(hsync_inter), .pre_l(1'b1));

   logic 	nc1, nc2, nc3, nc4;

   // Signal Output Bufer M4	   
   ls175 m4(.D({256HD, hcount[8], vblank_l, 1'b0}), 
	    .Q({nc1, 256HD, vblankd_l, nc2}), .Q_l({256H2D_l, 256HD_l, nc3, nc4}),
	    .clk(&({~clk_12096, hraw[3:0]})), .rst_l(1'b1));

   // VSYNC, VBLANK, and VRESET lookup table
   
   ls175 n4(
   
   
endmodule: synchronizer

// Note this is only 1 wide, actual chip had two FFs in one package
module ls74(input logic  D, 
	    input logic  clk, rst_l, pre_l,
	    output logic Q, Q_l);

   always_ff(@posedge clk, negedge rst_l, negedge pre_l)
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

   always_ff(@posedge clk, negedge rst_l) begin
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

endmodule: ls175



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

    
