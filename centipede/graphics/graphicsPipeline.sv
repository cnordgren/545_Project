//`define SIM
module graphicsPipeline(input logic        clk, rst_l,
			input logic 	   pfram_l,
			input logic [15:0] addr,
		        input logic [7:0]  data_in,
			output logic [7:0] data_out,

			output logic 	   VGA_HS, VGA_VS, VGA_BLANK_N, VGA_CLK, VGA_SYNC_N,
                        output logic [7:0] VGA_R, VGA_G, VGA_B);
   
   logic [2:0] staticTileRow, staticTileCol;
   logic [7:0] centRow, centCol;
   logic       motionSel, motionWide;
   logic [7:0] motionSpriteID, staticSpriteID;
   logic [2:0] mob_row, mob_col;
   logic [9:0] vga_col;
   logic [8:0] vga_row;
   logic       output_blank;
   logic [9:0] staticTileAddr;
   logic [1:0] colorCode;

   assign VGA_CLK = ~clk;
   assign VGA_SYNC_N = 1'b0;
   
   
   vga v(.CLOCK_100(clk), .reset(rst_l),
	 .HS(VGA_HS), .VS(VGA_VS), .blank_N(VGA_BLANK_N),
	 .row(vga_row), .col(vga_col));
   
   playfieldRAM pfram(.clk(clk), .rst_l(rst_l), .we_l(pfram_l),
                      .addrA(addr[9:0]), .addrB(staticTileAddr),
		      .datain(data_in),
		      .dataA(data_out), .dataB(staticSpriteID));
   
   computeTile compT(.col(vga_col), .row(vga_row),
		     .output_blank(output_blank),
		     .tileAddr(staticTileAddr), 
		     .tileRow(staticTileRow), .tileCol(staticTileCol),
		     .centRow(centRow), .centCol(centCol));
   
   pixelLookup pix(.staticSpriteID(staticSpriteID), .motionSpriteID(motionSpriteID),
		   .staticTileRow(staticTileRow), .staticTileCol(staticTileCol),
		   .motionTileRow(mob_row), .motionTileCol(mob_col),
		   .motionSelect(motionSel), .motionWide(motionWide), .clk(clk),
		   .colorCode(colorCode));
   
   motionObjects mobs(.clk(clk), .rst_l(rst_l), 
		      .row(centRow), .col(centCol),
		      .addr(addr), .data_in(data_in), .we_l(pfram_l),
		      .motionSel(motionSel), .motionWide(motionWide),
		      .spriteID(motionSpriteID), 
		      .mob_row(mob_row), .mob_col(mob_col));
	
   always_comb begin
      VGA_R = 8'h0F;
      VGA_B = 8'h0F;
      VGA_G = 8'h0F;
      if(~output_blank) begin
	 case(colorCode)
	   2'd1: begin
	      VGA_R = 8'hFF;
	      VGA_G = 8'h00;
	      VGA_B = 8'h00;
	   end
	   2'd2: begin
	      VGA_R = 8'h0;
	      VGA_G = 8'hFF;
	      VGA_B = 8'd0;	      
	   end
	   2'd3: begin
	      VGA_R = 8'hFF;
	      VGA_G = 8'hFF;
	      VGA_B = 8'hFC;
	   end
	   default: begin
	      VGA_R = 8'h00;
	      VGA_G = 8'h00;
	      VGA_B = 8'h00;
	   end
	 endcase // case (colorCode)
      end
   end

endmodule: graphicsPipeline
/*
`ifdef SIM
module test();
   logic clk, rst_l;
   logic HS, VS;
   logic [7:0] R, G, B;

   
   
   graphicsPipeline gp(.CLOCK_50(clk), .KEY({3'd0,rst_l}), .VGA_HS(HS), .VGA_VS(VS),
		       .VGA_R(R), .VGA_B(B), .VGA_G(G));

   initial begin
      clk = 1;
      forever #5 clk = ~clk;
   end

   initial begin
      
      rst_l = 1'b0;
      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      #1 rst_l = 1'b1;
      @(posedge clk);
      repeat(1000000) begin
	 @(posedge clk);
      end
      $finish;
      
   end

endmodule: test
`endif

*/