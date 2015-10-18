module distortChn_testbench();
    logic       chnIn, poly4, poly5, poly17_9;
    logic [2:0] distort;
    logic       chnOut_distort;

    distortChn  dcn(chnIn, poly4, poly5, poly17_9, distort, chnOut_distort);

    initial begin
       #10 chnIn = 0;
           poly4 = 0;
           poly5 = 0;
           poly17_9 = 0;
           distort = 3'd2;
      #50  chnIn = 1;
           poly4 = 1;
      #100 poly17_9 = 1;
           distort = 3'd7;
      #50  //poly17_9 = 0;
           poly5 = 1;
           distort = 3'd2;
           poly4 = 0;

    end
endmodule
