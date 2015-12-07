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
module pixelLookup(input logic [7:0]  staticSpriteID, motionSpriteID,
		   input logic [2:0]  staticTileRow, staticTileCol,
		   input logic [2:0]  motionTileRow, motionTileCol,
		   input logic 	      motionSelect, motionWide, clk,
		   output logic [1:0] colorCode);

   logic [7:0]  motionPixels[14'd9856];
   logic [7:0]  staticPixels[12'd2560];
   logic [13:0] index;
   logic [3:0] 	spriteRow, spriteCol;
   logic 	motionLookup;
   logic [7:0] 	spriteID;
   logic [2:0] 	tileRow, tileCol;	
   logic [2:0] 	lookupRow, lookupCol;
   logic [7:0] 	spOut, mpOut;
   
   // Fill the pixel ROMs
   initial begin
      $readmemh("MotionObject.hex", motionPixels);
      $readmemh("StaticObject.hex", staticPixels);
   end

   // Select the right ID based on motionSelect
   assign spriteID = (motionSelect) ? motionSpriteID : staticSpriteID;
   assign tileRow = (motionSelect) ? motionTileRow : staticTileRow;
   assign tileCol = (motionSelect) ? motionTileCol : staticTileCol;
   
   // Index the correct array of pixel data
   always_ff@(posedge clk) begin
      mpOut <= motionPixels[index];
      spOut <= staticPixels[index];
   end

   assign colorCode = (motionSelect | motionLookup) ? mpOut[1:0] : spOut[1:0];

   // Flip the sprites as requested by the flip bits spriteID[7:6]
   assign lookupRow = (spriteID[6]) ? (3'b111 - tileRow) : tileRow;
   assign lookupCol = (spriteID[7]) ? (3'b111 - tileCol) : tileCol;
   
   // Compute the lookup index for the memory array
   always_comb begin
      if(motionSelect | motionLookup)
	// Motion lookup is 112 x 88
	if(motionWide)
	  index = 112*((spriteRow*8)+lookupRow) + (8*(spriteCol+1))+lookupCol;
	else
	  index = 112*((spriteRow*8)+lookupRow) + (8*spriteCol)+lookupCol;
      else
	// Static lookup is 80 x 32
	index = 80*((spriteRow*8)+lookupRow) + (8*spriteCol)+lookupCol;
   end
				 
   always_comb begin
      motionLookup = 0;
      if(motionSelect) begin
	 case(spriteID[5:0])
	   6'h00: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd0;
	   end
	   6'h01: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd1;
	   end
	   6'h02: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd2;
	   end
	   6'h03: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd3;
	   end
	   6'h04: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd0;
	   end
	   6'h05: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd1;
	   end
	   6'h06: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd2;
	   end
	   6'h07: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd3;
	   end
	   6'h08: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd4;
	   end
	   6'h09: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd5;
	   end
	   6'h0A: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd4;
	   end
	   6'h0B: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd5;
	   end
	   6'h0C: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd6;
	   end
	   6'h0D: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd7;
	   end
	   6'h0E: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd6;
	   end
	   6'h0F: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd7;
	   end
	   6'h10: begin
	      spriteRow = 4'd10;
	      spriteCol = 4'd0;
	   end
	   6'h11: begin
	      spriteRow = 4'd10;
	      spriteCol = 4'd1;
	   end
	   // 12 is blank
	   // 13 is blank
	   // Spider Sprites
	   6'h14: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd4;
	      spriteCol = 4'd0;
	   end
	   6'h15: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd4;
	      spriteCol = 4'd2;
	   end
	   6'h16: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd4;
	      spriteCol = 4'd4;
	   end
	   6'h17: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd4;
	      spriteCol = 4'd6;
	   end
	   6'h18: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd5;
	      spriteCol = 4'd0;
	   end
	   6'h19: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd5;
	      spriteCol = 4'd2;
	   end
	   6'h1A: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd5;
	      spriteCol = 4'd4;
	   end
	   6'h1B: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd5;
	      spriteCol = 4'd6;
	   end
	   // Aphid Sprites
	   6'h1C: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd4;
	      spriteCol = 4'd8;
	   end
	   6'h1D: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd4;
	      spriteCol = 4'd10;
	   end
	   6'h1E: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd5;
	      spriteCol = 4'd8;
	   end
	   6'h1F: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd5;
	      spriteCol = 4'd10;
	   end
	   // Explosion 1 Sprites
	   6'h20: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd8;
	      spriteCol = 4'd0;
	   end
	   6'h21: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd9;
	      spriteCol = 4'd0;
	   end
	   6'h22: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd8;
	      spriteCol = 4'd2;
	   end
	   6'h23: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd9;
	      spriteCol = 4'd2;
	   end
	   6'h24: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd8;
	      spriteCol = 4'd4;
	   end
	   6'h25: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd9;
	      spriteCol = 4'd4;
	   end
	   6'h26: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd8;
	      spriteCol = 4'd6;
	   end
	   6'h27: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd9;
	      spriteCol = 4'd6;
	   end
	   // 28-2B are blank
	   // Cricket Sprites
	   6'h2C: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd6;
	      spriteCol = 4'd0;
	   end
	   6'h2D: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd6;
	      spriteCol = 4'd2;
	   end
	   6'h2E: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd6;
	      spriteCol = 4'd4;
	   end
	   6'h2F: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd6;
	      spriteCol = 4'd6;
	   end
	   // Slug Sprites
	   6'h30: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd7;
	      spriteCol = 4'd0;
	   end
	   6'h31: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd7;
	      spriteCol = 4'd2;
	   end
	   6'h32: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd7;
	      spriteCol = 4'd4;
	   end
	   6'h33: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd7;
	      spriteCol = 4'd6;
	   end
	   // 34-35 are blank
	   // Number Sprites
	   6'h36: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd0;
	      spriteCol = 4'd12;
	   end
	   6'h37: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd1;
	      spriteCol = 4'd12;
	   end	      
	   6'h38: begin
	      // DOUBLE WIDE TILE
	      spriteRow = 4'd2;
	      spriteCol = 4'd12;
	   end
	   // 39 is blank
	   // Explosion 2 sprites
	   6'h3A: begin
	      spriteRow = 4'd8;
	      spriteCol = 4'd10;
	   end
	   6'h3B: begin 
	      spriteRow = 4'd9;
	      spriteCol = 4'd10;
	   end
	   6'h3C: begin
	      spriteRow = 4'd9;
	      spriteCol = 4'd9;
	   end
	   6'h3D: begin
	      spriteRow = 4'd8;
	      spriteCol = 4'd9;
	   end
	   6'h3E: begin
	      spriteRow = 4'd9;
	      spriteCol = 4'd8;
	   end
	   6'h3F: begin
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
	 case(spriteID[5:0])
	   6'h00: begin
	      motionLookup = 1'b1;
	      spriteRow = 4'd10;
	      spriteCol = 4'd2;
	   end
	   6'h01: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd0;
	   end
	   6'h02: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd1;
	   end
	   6'h03: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd2;
	   end
	   6'h04: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd3;
	   end
	   6'h05: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd4;
	   end
	   6'h06: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd5;
	   end
	   6'h07: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd6;
	   end
	   6'h08: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd7;
	   end
	   6'h09: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd8;
	   end
	   6'h0A: begin
	      spriteRow = 4'd0;
	      spriteCol = 4'd9;
	   end
	   6'h0B: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd0;
	   end
	   6'h0C: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd1;
	   end
	   6'h0D: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd2;
	   end
	   6'h0E: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd3;
	   end
	   6'h0F: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd4;
	   end
	   6'h10: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd5;
	   end
	   6'h11: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd6;
	   end
	   6'h12: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd7;
	   end
	   6'h13: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd8;
	   end
	   6'h14: begin
	      spriteRow = 4'd1;
	      spriteCol = 4'd9;
	   end
	   6'h15: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd0;
	   end
	   6'h16: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd1;
	   end
	   6'h17: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd2;
	   end
	   6'h18: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd3;
	   end
	   6'h19: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd4;
	   end
	   6'h1A: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd5;
	   end
	   6'h1B: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd6;
	   end
	   6'h1C: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd7;
	   end
	   6'h1D: begin // DOT WILL RENDER AS COLON
	      spriteRow = 4'd2;
	      spriteCol = 4'd9;
	   end
	   6'h1E: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd8;
	   end
	   6'h1F: begin
	      // THIS IS IN THE MOTION TABLE
	      motionLookup = 1'b1;
	      spriteRow = 4'd10;
	      spriteCol = 4'd0;
	   end
	   6'h20: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd0;
	   end
	   6'h21: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd1;
	   end
	   6'h22: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd2;
	   end
	   6'h23: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd3;
	   end
	   6'h24: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd4;
	   end
	   6'h25: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd5;
	   end
	   6'h26: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd6;
	   end
	   6'h27: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd7;
	   end
	   6'h28: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd8;
	   end
	   6'h29: begin
	      spriteRow = 4'd3;
	      spriteCol = 4'd9;
	   end
	   // 2A is a blank sprite
	   // 2B is a color block, unused
	   // 2C is a color block, unused
	   // 2D is a color block, unused
	   6'h2E: begin
	      spriteRow = 4'd2;
	      spriteCol = 4'd9;
	   end
	   // 2F is blank
	   // 30-37 are blank
	   6'h38: begin
	      // IN THE MOTION ROM
	      motionLookup = 1'b1;
	      spriteRow = 4'd1;
	      spriteCol = 4'd8;
	   end
	   6'h39: begin
	      // IN THE MOTION ROM
	      motionLookup = 1'b1;
	      spriteRow = 4'd1;
	      spriteCol = 4'd9;
	   end
	   6'h3A: begin
	      // IN THE MOTION ROM	  
	      motionLookup = 1'b1;
	      spriteRow = 4'd1;
	      spriteCol = 4'd10;
	   end
	   6'h3B: begin
	      // IN THE MOTION ROM
	      motionLookup = 1'b1; 
	      spriteRow = 4'd1;
	      spriteCol = 4'd11;
	   end
	   6'h3C: begin
	      // IN THE MOTION ROM
	      motionLookup = 1'b1;
	      spriteRow = 4'd0;
	      spriteCol = 4'd8;
	   end
	   6'h3D: begin
	      // IN THE MOTION ROM
	      motionLookup = 1'b1;
	      spriteRow = 4'd0;
	      spriteCol = 4'd9;
	   end
	   6'h3E: begin
	      // IN THE MOTION ROM
	      motionLookup = 1'b1;
	      spriteRow = 4'd0;
	      spriteCol = 4'd10;
	   end
	   6'h3F: begin
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

`ifdef plSIM
module test();

   logic [7:0] spriteID;
   logic [2:0] tileRow, tileCol;
   logic       motionSelect, motionWide, clk;
   logic [1:0] colorCode;

   pixelLookup dut(.*);

   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end

   task renderSprite();
      int i, j;
      for(i=0; i < 8; i++) begin
	 tileRow = i;
	 for(j=0; j<8; j++) begin
	    tileCol = j;
	    @(posedge clk);
	 end
      end
   endtask // renderSprite
   
   
   initial begin
      spriteID = 8'h01;
      motionSelect = 1'b0;
      motionWide = 1'b0;
      tileRow = 3'd0;
      tileCol = 3'd0;
      @(posedge clk);
      renderSprite();
      @(posedge clk);
      spriteID = 8'h1F;
      renderSprite();
      @(posedge clk);
      spriteID = 8'h01;
      motionSelect = 1'b1;
      renderSprite();
      @(posedge clk);
      $finish;
   end

endmodule: test
`endif
