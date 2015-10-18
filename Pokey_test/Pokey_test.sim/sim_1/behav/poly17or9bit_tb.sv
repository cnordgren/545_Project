module poly17or9bit_tb();
    logic clk, sel9, init_L, out;
    logic  [7:0] randNum;

    poly17or9bit  po(clk, sel9, init_L, out, randNum);

    initial begin
       repeat(10000) #5 clk = ~clk;
    end

    initial begin
       sel9 = 1'b0;
       clk = 0;
       init_L = 1'b0;
       #10 init_L = 1'b1;
           sel9 = 1'b1;
       #100 init_L = 1'b0;
       #10  init_L = 1'b1;
            //sel9 = 1'b0;
            #200;

    end

endmodule
