/*
 * This module takes in a spriteID from VRAM and the motion
 * object circuitry and based on the row and col within that sprite
 * outputs the color code for that pixel to the Color ROM lookup
 *
 * spriteID: the ID from the VRAM that identifies the sprite we want to render
 * tileRow: the row from computeTile that tells us what row of the screen tile we are in
 * tileCol: the column from computeTile that tells us what col of the screen tile we are in
 * motionSelect: Input from motion object match ciruitry, tells us we are using motion object
 * motionWide: Input from the motion object match circuitry, tells us to use 2nd tile of object
 * colorCode: Output to CRAM lookup that indicates which of the 4 colors to use
 */
module pixelLookup(input logic [7:0]  spriteID,
		   input logic [2:0]  tileRow, tileCol,
		   input logic 	      motionSelect, motionWide, clk,
		   output logic [1:0] colorCode);
   
   logic [9855:0][7:0] motionPixels;
   logic [2559:0][7:0] staticPixels;
   logic [13:0]        index;
   logic [3:0] 	       spriteRow, spriteCol;
   logic 	       motionLookup;
   
   // Fill the pixel ROMs
   initial begin
      $readmemb("MotionObject.hex", motionPixels);
      $readmemb("StaticObject.hex", staticPixels);
   end

   // Index the correct array of pixel data
   always_ff@(posedge clk) begin
      if(motionSelect | motionLookup)
	colorCode <= motionPixels[index];
      else
	colorCode <= staticPixels[index];
   end

   // Compute the lookup index for the memory array
   always_comb begin
      if(motionSelect | motionLookup)
	// Motion lookup is 112 x 88
	index = 112*((spriteRow*8)+tileRow) + 80*((spriteCol*8)+tileCol);
      else
	// Static lookup is 80 x 32
	index = 80*((spriteRow*8)+tileRow) + 32*((spriteCol*8)+tileCol);
   end
				 
   always_comb begin
      motionLookup = 0;
      if(motionSelect) begin
	 case(spriteID)
	   8'h00: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd0;
	   end
	   8'h01: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd1;
	   end
	   8'h02: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd2;
	   end
	   8'h03: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd3;
	   end
	   8'h04: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd0;
	   end
	   8'h05: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd1;
	   end
	   8'h06: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd2;
	   end
	   8'h07: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd3;
	   end
	   8'h08: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd4;
	   end
	   8'h09: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd5;
	   end
	   8'h0A: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd4;
	   end
	   8'h0B: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd5;
	   end
	   8'h0C: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd6;
	   end
	   8'h0D: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd7;
	   end
	   8'h0E: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd6;
	   end
	   8'h0F: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd7;
	   end
	   8'h10: begin
	      spriteRow = 4'd10;
	      spriteCol = 4'd0;
	   end
	   8'h11: begin
	      spriteRow = 4'd10;
	      spriteCol = 4'd1;
	   end
	   // 12 is blank
	   // 13 is blank
	   // Spider Sprites
	   8'h14: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd4;
	      spriteCol = 4'd0;
	   end
	   8'h15: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd4;
	      spriteCol = 4'd2;
	   end
	   8'h16: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd4;
	      spriteCol = 4'd4;
	   end
	   8'h17: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd4;
	      spriteCol = 4'd6;
	   end
	   8'h18: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd5;
	      spriteCol = 4'd0;
	   end
	   8'h19: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd5;
	      spriteCol = 4'd2;
	   end
	   8'h1A: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd5;
	      spriteCol = 4'd4;
	   end
	   8'h1B: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd5;
	      spriteCol = 4'd6;
	   end
	   // Aphid Sprites
	   8'h1C: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd4;
	      spriteCol = 4'd8;
	   end
	   8'h1D: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd4;
	      spriteCol = 4'd10;
	   end
	   8'h1E: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd5;
	      spriteCol = 4'd8;
	   end
	   8'h1F: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd5;
	      spriteCol = 4'd10;
	   end
	   // Explosion 1 Sprites
	   8'h20: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd8;
	      spriteCol = 4'd0;
	   end
	   8'h21: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd9;
	      spriteCol = 4'd0;
	   end
	   8'h22: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd8;
	      spriteCol = 4'd2;
	   end
	   8'h23: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd9;
	      spriteCol = 4'd2;
	   end
	   8'h24: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd8;
	      spriteCol = 4'd4;
	   end
	   8'h25: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd9;
	      spriteCol = 4'd4;
	   end
	   8'h26: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd8;
	      spriteCol = 4'd6;
	   end
	   8'h27: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd9;
	      spriteCol = 4'd6;
	   end
	   // 28-2B are blank
	   // Cricket Sprites
	   8'h2C: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd6;
	      spriteCol = 4'd0;
	   end
	   8'h2D: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd6;
	      spriteCol = 4'd2;
	   end
	   8'h2E: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd6;
	      spriteCol = 4'd4;
	   end
	   8'h2F: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd6;
	      spriteCol = 4'd6;
	   end
	   // Slug Sprites
	   8'h30: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd7;
	      spriteCol = 4'd0;
	   end
	   8'h31: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd7;
	      spriteCol = 4'd2;
	   end
	   8'h32: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd7;
	      spriteCol = 4'd4;
	   end
	   8'h33: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd7;
	      spriteCol = 4'd6;
	   end
	   // 34-35 are blank
	   // Number Sprites
	   8'h36: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd0;
	      spriteCol = 4'd12;
	   end
	   8'h37: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd1;
	      spriteCol = 4'd12;
	   end	      
	   8'h38: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd2;
	      spriteCol = 4'd12;
	   end
	   // 39 is blank
	   // Explosion 2 sprites
	   8'h3A: begin
	      spriteRow = 4'd8;
	      spriteCol = 4'd10;
	   end
	   8'h3B: begin 
	      spriteRow = 4'd9;
	      spriteCol = 4'd10;
	   end
	   8'h3C: begin
	      spriteRow = 4'd9;
	      spriteCol = 4'd9;
	   end
	   8'h3D: begin
	      spriteRow = 4'd8;
	      spriteCol = 4'd9;
	   end
	   8'h3E: begin
	      spriteRow = 4'd9;
	      spriteCol = 4'd8;
	   end
	   8'h3F: begin
	      spriteRow = 4'd8;
	      spriteCol = 4'd8;
	   end
	   default: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd0;
	   end
	 endcase // case (staticSpriteID)
      end
      else begin
	 case(spriteID)
	   8'h01: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd0;
	   end
	   8'h02: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd1;
	   end
	   8'h03: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd2;
	   end
	   8'h04: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd3;
	   end
	   8'h05: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd4;
	   end
	   8'h06: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd5;
	   end
	   8'h07: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd6;
	   end
	   8'h08: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd7;
	   end
	   8'h09: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd8;
	   end
	   8'h0A: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd9;
	   end
	   8'h0B: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd0;
	   end
	   8'h0C: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd1;
	   end
	   8'h0D: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd2;
	   end
	   8'h0E: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd3;
	   end
	   8'h0F: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd4;
	   end
	   8'h10: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd5;
	   end
	   8'h11: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd6;
	   end
	   8'h12: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd7;
	   end
	   8'h13: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd8;
	   end
	   8'h14: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd9;
	   end
	   8'h15: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd0;
	   end
	   8'h16: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd1;
	   end
	   8'h17: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd2;
	   end
	   8'h18: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd3;
	   end
	   8'h19: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd4;
	   end
	   8'h1A: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd5;
	   end
	   8'h1B: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd6;
	   end
	   8'h1C: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd7;
	   end
	   8'h1D: begin // DOT WILL RENDER AS COLON
	      spriteRow = 4'd2;
	      spriteCol = 4'd9;
	   end
	   8'h1E: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd8;
	   end
	   8'h1F: begin
	      // THIS IS IN THE MOTION TABLE
	      motionLookup = 1'b1;
	      spriteRow = 4'd10;
	      spriteCol = 4'd0;
	   end
	   8'h20: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd0;
	   end
	   8'h21: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd1;
	   end
	   8'h22: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd2;
	   end
	   8'h23: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd3;
	   end
	   8'h24: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd4;
	   end
	   8'h25: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd5;
	   end
	   8'h26: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd6;
	   end
	   8'h27: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd7;
	   end
	   8'h28: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd8;
	   end
	   8'h29: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd9;
	   end
	   // 2A is a blank sprite
	   // 2B is a color block, unused
	   // 2C is a color block, unused
	   // 2D is a color block, unused
	   8'h2E: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd9;
	   end
	   // 2F is blank
	   // 30-37 are blank
	   8'h38: begin
	      // IN THE MOTION ROM
	      motionLookup = 1'b1;
	      spriteRow = 4'd1;
	      spriteCol = 4'd8;
	   end
	   8'h39: begin
	      // IN THE MOTION ROM
	      motionLookup = 1'b1;
	      spriteRow = 4'd1;
	      spriteCol = 4'd9;
	   end
	   8'h3A: begin
	      // IN THE MOTION ROM	  
	      motionLookup = 1'b1;
	      spriteRow = 4'd1;
	      spriteCol = 4'd10;
	   end
	   8'h3B: begin
	      // IN THE MOTION ROM
	      motionLookup = 1'b1; 
	      spriteRow = 4'd1;
	      spriteCol = 4'd11;
	   end
	   8'h3C: begin
	      // IN THE MOTION ROM
	      motionLookup = 1'b1;
	      spriteRow = 4'd0;
	      spriteCol = 4'd8;
	   end
	   8'h3D: begin
	      // IN THE MOTION ROM
	      motionLookup = 1'b1;
	      spriteRow = 4'd0;
	      spriteCol = 4'd9;
	   end
	   8'h3E: begin
	      // IN THE MOTION ROM
	      motionLookup = 1'b1;
	      spriteRow = 4'd0;
	      spriteCol = 4'd10;
	   end
	   8'h3F: begin
	      // IN THE MOTION ROM
	      motionLookup = 1'b1;
	      spriteRow = 4'd0;
	      spriteCol = 4'd11;
	   end
	   default: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd0;
	   end
	 endcase // case (staticSpriteID)
      end // else: !if(motionSelect)
   end

endmodule: pixelLookup
