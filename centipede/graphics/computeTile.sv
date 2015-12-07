module computeTile(input logic [9:0] col,
		   input logic [8:0]  row,
		   output logic       output_blank,
		   output logic [9:0] tileAddr,
		   output logic [2:0] tileRow, tileCol,
		   output logic [7:0] centRow, centCol);
   
   logic [9:0] 			      interCol;
   
   // Calculate values to center the screen
   always_comb begin
      //centRow = row - 9'd120; // Goes from 0-239 when blank is low
      //centCol = col - 10'd192; // Goes from 0-255 when blank is low
      interCol = col - 10'd64;
      centRow = 8'd239 - row[8:1];
      // Off by one for some reason, don't ask me why.  It's a hack.
      centCol = 8'd254 - interCol[9:1];  
 
      // If we aren't in the area of VGA where centipede's screen is, don't do anything
      if(col < 10'd64 || col >= 10'd576) begin
	 output_blank = 1'b1;
	 tileRow = 3'd0;
	 tileCol = 3'd0;
	 tileAddr = 10'd0;
      end
      else begin
	 output_blank = 1'b0;
	 tileRow = centRow[2:0];
	 tileCol = centCol[2:0];
	 tileAddr = (32 * centRow[7:3]) + ({5'd0, centCol[7:3]});
      end // else: !if(col < 10'd64 || col >= 10'd576)
   end
endmodule: computeTile
