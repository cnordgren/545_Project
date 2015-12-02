module test_trackball();

    logic [1:0] hordir, horclk, verdir, verclk;
    logic rstclr_l, steerclr, flip;
    logic dir1, dir2;
    logic [3:0] tra, trb;

    trackball tb(.hordir(hordir), .horclk(horclk), .verdir(verdir), .verclk(verclk), .rstclr_l(rstclr_l), .steerclr(steerclr), .flip(flip), .dir1(dir1), .dir2(dir2), .tra(tra), .trb(trb));

    initial begin
     #10 hordir = 2'b01;
         horclk = 2'b00;
	       verdir = 2'b00;
	       verclk = 2'b00;
   	     rstclr_l = 1'b0;
	       steerclr = 1'b0;
	       flip = 1'b0;
     #1 horclk = 2'b01;
        verclk = 2'b01;
     #1 horclk = 2'b00;
        verclk = 2'b00;
        rstclr_l = 1'b1;
        steerclr = 1'b1;
     #1 horclk = 2'b01;
//        verclk = 2'b01;
     #1 horclk = 2'b00;
//        verclk = 2'b00;
     #1 horclk = 2'b01;
//        verclk = 2'b01;
     #1 horclk = 2'b00;
//        verclk = 2'b00;
     #1 horclk = 2'b01;
 //       verclk = 2'b01;
     #1 horclk = 2'b00;
 //       verclk = 2'b00;
     #1 horclk = 2'b01;
//        verclk = 2'b01;
     #1 horclk = 2'b00;
//        verclk = 2'b00;
     #1 horclk = 2'b01;
//        verclk = 2'b01;
     #1 horclk = 2'b00;
//        verclk = 2'b00;
     #1 horclk = 2'b01;
//        verclk = 2'b01;
     #1 horclk = 2'b00;
//        verclk = 2'b00;
     #1 horclk = 2'b01;
//        verclk = 2'b01;
     #1 horclk = 2'b00;
  //      verclk = 2'b00;
     #1 horclk = 2'b01;
   //     verclk = 2'b01;
     #1 horclk = 2'b00;
   //     verclk = 2'b00;
     #1 horclk = 2'b01;
   //     verclk = 2'b01;
     #1 horclk = 2'b00;
   //     verclk = 2'b00;
     #1 horclk = 2'b01;
    //    verclk = 2'b01;
     #1 horclk = 2'b00;
   //     verclk = 2'b00;
      
     
       #100 $display("hordir=%b, horclk=%b, verdir=%b, verclk=%b, rstclr_l=%b, steerclr=%b, flip=%b, dir1=%b, dir2=%b, tra=%b, trb=%b", hordir, horclk, verdir, verclk, rstclr_l, steerclr, flip, dir1, dir2, tra, trb);

    end



endmodule
