`define TEST
module motionObjects(// Global inputs
		     input logic 	clk, rst_l,
		     // Inputs from computeTile
		     input logic [7:0] 	row, col,
		     // Inputs from 6502 memory bus (we're acting as MMIO)
		     input logic [15:0] addr, 
		     input logic [7:0] 	data_in,
		     input logic 	we_l,
		     // Outputs to pixelLookup
		     output logic 	motionSel, motionWide,
		     output logic [7:0] spriteID,
		     output logic [2:0] mob_row, mob_col);

   // Hold motion object data
   logic [15:0][7:0] mob_horz, mob_vert, mob_ID;
   logic [15:0][7:0] mob_horzd, mob_vertd, mob_IDd;
   
   logic [7:0] 	     mob_height;
   logic 	     updateHorz, updateVert, updateID;

   logic [15:0][7:0]  width;
   logic [7:0] 	      checkRow;

   assign checkRow = 8'd239 - row;
   
   // Define the width of the motion objects

   always_comb begin
      int i;
      for(i=0; i<12; i++) begin
	 width[i] = 8'd8;
      end
      width[12] = 8'd16;
      width[13] = 8'd16;
      width[14] = 8'd8;
      width[15] = 8'd8;
      mob_height = 8'd8;
   end
   
   // Check for a hit on the motion object
   always_comb begin
      int i;
      // Initialize values to not asserted
      motionSel = 1'b0;
      motionWide = 1'b0;
      spriteID = 8'd0;
      mob_row = 3'd0;
      mob_col = 3'd0;

      
      // Check for a hit on each mob
      // Should only be one hit at a time so no collisions to worry about
      for(i=0; i<16; i++) begin
	 if((checkRow <= mob_vert[i]) && // Check top
	    (checkRow > (mob_vert[i] - width[i])) && // Check bottom
	    (col >= mob_horz[i]) && // Check left
	    (col < (mob_horz[i] + mob_height))) begin // Check right
	    // We have a hit
	    motionSel = 1'b1;
	    spriteID = mob_ID[i];
	    mob_col = col - mob_horz[i]; 
	    
	    // See if we're in the 2nd tile of a wide sprite
	    if(width[i] == 8'd16 && checkRow < (mob_vert[i] - 8'd8)) begin
	       motionWide = 1'b1;
	       mob_row = ~(checkRow - mob_vert[i] + 8'd8);
	    end
	    else begin
	       motionWide = 1'b0;
	       mob_row = ~(checkRow - mob_vert[i] - 8'd1);
	    end // else: !if(width[i] == 8'd16 && checkRow < (mob_vert[i] - 8'd8))
	    break;
	 end
      end // for (i=0; i<15; i++)      
   end
   
   // Check if we are updating motion object data
   always_comb begin
      updateHorz = 1'b0;
      updateVert = 1'b0;
      updateID = 1'b0;
      mob_IDd = mob_ID;
      mob_vertd = mob_vert;
      mob_horzd = mob_horz;
      
      if(~we_l)
	// We're writing to the motion object picture
	if(addr[15:4] == 12'h07C) begin
	   updateID = 1'b1;
	   mob_IDd[addr[3:0]] = data_in;
	end
	else if(addr[15:4] == 12'h07D) begin
	   updateVert = 1'b1;
	   mob_vertd[addr[3:0]] = data_in;
	end
	else if(addr[15:4] == 12'h07E) begin
	   updateHorz = 1'b1;
	   mob_horzd[addr[3:0]] = data_in;
	end
   end
   `ifndef TEST
   // Update the state registers holding motion object data
   always_ff@(posedge clk, negedge rst_l) begin
      if(~rst_l) begin
	 mob_horz <= 0;
	 mob_vert <= 0;
	 mob_ID <= 0;
      end
      else begin
	 mob_horz <= mob_horzd;
	 mob_vert <= mob_vertd;
	 mob_ID <= mob_IDd;
      end
   end // always_ff@
   `else // !`ifndef TEST
   // Test screen with full centipede, spider, laser and player
//   assign mob_ID = {8'h85, 8'h84, 8'h83, 8'h82, 8'h81, 8'h80, 8'h87, 8'h86, 
//		    8'h85, 8'h84, 8'h83, 8'h82, 8'h1C, 8'h19, 8'h11, 8'h10};
   assign mob_ID = {8'h10, 8'h11, 8'h19, 8'h1C, 8'h82, 8'h83, 8'h84, 8'h85,
		    8'h86, 8'h87, 8'h80, 8'h81, 8'h82, 8'h83, 8'h84, 8'h85};
   
//   assign mob_vert = {8'h59, 8'h61, 8'h69, 8'h71, 8'h79, 8'h81, 8'h89, 8'h91,
//		      8'h99, 8'hA1, 8'hA9, 8'hB1, 8'hA4, 8'hC1, 8'h36, 8'h36};
   assign mob_vert = {8'hF0, 8'h36, 8'h30, 8'hA4, 8'hB1, 8'hA9, 8'hA1, 8'h99,
		      8'h91, 8'h89, 8'h81, 8'h79, 8'h71, 8'h69, 8'h61, 8'h59};
   
//   assign mob_horz = {8'h98, 8'h98, 8'h98, 8'h98, 8'h98, 8'h98, 8'h98, 8'h98,
//		      8'h98, 8'h98, 8'h98, 8'h98, 8'hF8, 8'h23, 8'hAA, 7'h28};
   assign mob_horz = {8'h00, 8'hAA, 8'h23, 8'hC8, 8'h98, 8'h98, 8'h98, 8'h98,
		      8'h98, 8'h98, 8'h98, 8'h98, 8'h98, 8'h98, 8'h98, 8'h98};
   
   `endif

endmodule: motionObjects

`ifdef moSIM
module test();
   logic        clk, rst_l;
   logic [7:0]  row, col;
   logic [15:0] addr;
   logic [7:0] 	data_in;
   logic 	we_l;
   logic 	motionSel, motionWide;
   logic [7:0] 	spriteID;
   logic [2:0] 	mob_row, mob_col;

   motionObjects dut(.*);

   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end

   initial begin
      rst_l = 1'b0;
      row = 8'd0;
      col = 8'd0;
      addr = 16'd0;
      we_l = 1'b1;
      data_in = 8'd0;
      @(posedge clk);
      rst_l = 1'b1;
      @(posedge clk);
      // Make sure the MMIO works load a value into a register
      data_in = 8'h01;
      we_l = 1'b0;
      addr = 16'h07C0;
      @(posedge clk);
      data_in = 8'h0A;
      addr = 16'h07D0;
      @(posedge clk);
      addr = 16'h07E0;
      @(posedge clk);
      we_l = 1'b1;
      // Top left corner hit
      row = 8'd10;
      col = 8'd10;
      @(posedge clk);
      // Hit middle
      row = 8'd8;
      col = 8'd12;
      @(posedge clk);
      // Boundary miss left
      row = 8'd5;
      col = 8'd9;
      @(posedge clk);
      // Boundary miss right
      row = 8'd5;
      col = 8'd18;
      @(posedge clk);
      // Boundary miss top
      row = 8'd11;
      col = 8'd14;
      @(posedge clk);
      // Boundary miss bottom
      row = 8'd2;
      col = 8'd14;
      @(posedge clk);
      // Bottom right corner hit
      row = 8'd3;
      col = 8'd17;
      @(posedge clk);
      @(posedge clk);
      // Switch to wide sprite test extra tile hits
      we_l = 1'b0;
      addr = 16'h07C0;
      data_in = 8'h14;
      @(posedge clk);
      we_l = 1'b1;
      @(posedge clk);
      // Top left corner hit
      row = 8'd10;
      col = 8'd10;
      @(posedge clk);
      // Hit middle
      row = 8'd8;
      col = 8'd12;
      @(posedge clk);
      // Boundary miss left
      row = 8'd5;
      col = 8'd9;
      @(posedge clk);
      // Boundary miss right
      row = 8'd5;
      col = 8'd26;
      @(posedge clk);
      // Boundary miss top
      row = 8'd11;
      col = 8'd14;
      @(posedge clk);
      // Boundary miss bottom
      row = 8'd2;
      col = 8'd14;
      @(posedge clk);
      // Bottom right corner hit
      row = 8'd3;
      col = 8'd25;
      @(posedge clk);
      @(posedge clk);
      
      
      $finish;
   end
      
endmodule: test
`endif
