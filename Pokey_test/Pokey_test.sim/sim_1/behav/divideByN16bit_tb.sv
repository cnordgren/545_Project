module divideByN_16bit_tb();  
    logic        strobe, in, def, out, interrupt;
    logic [15:0] N;

    divideByN16bit  dbn(strobe, N, in, def, out, interrupt);

    initial begin
       repeat (10000) #5 in = ~in;
    end

    initial begin
       def = 1;
       in = 0;
       strobe = 0;

       N = 16'd32;
       #200 strobe = 1;
       //#20  strobe = 0;
    end

endmodule
