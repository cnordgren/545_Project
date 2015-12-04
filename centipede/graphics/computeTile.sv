module computeTile(input logic [9:0] col,
		   input logic [8:0]  row,
		   input logic 	      vga_blank,
		   output logic       output_blank,
		   output logic [7:0] tileAddr,
		   output logic [2:0] tileRow, tileCol);

   logic [7:0] centRow, centCol;
   
   // Calculate values to center the screen
   always_comb begin
      centRow = row - 9'd120; // Goes from 0-239 when blank is low
      centCol = col - 10'd192; // Goes from 0-255 when blank is low

      // If we aren't in the area of VGA where centipede's screen is, don't do anything
      if(row < 9'd120 || row >= 9'd360
	 || col < 10'd192 || col >= 10'd448 || vga_blank == 1'b1) begin
	 output_blank = 1'b1;
	 tileRow = 3'd0;
	 tileCol = 3'd0;
	 tileAddr = 8'd0;
      end
      else begin
	 blank = 1'b0;
	 tileRow = centRow[2:0];
	 tileCol = centCol[2:0];
	 tileAddr = (centRow >> 5) + centCol;
      end // else: !if(row < 9'd120 || row >= 9'd360...
   end
endmodule: computeTile
