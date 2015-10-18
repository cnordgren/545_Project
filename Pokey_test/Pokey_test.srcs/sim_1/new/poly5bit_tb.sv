
module poly5bit_tb();
    logic clk, init_L, out;

    poly5bit  p5b(clk, init_L, out);

    initial begin
      repeat(10000) #5 clk = ~clk;
    end

    initial begin
       clk = 0;
       init_L = 1'b0;
       #10 init_L = 1'b1;
    end
endmodule
