
module highpass_tb();
    logic orig, filter, out;

    highpass hp(orig, filter, out);

    initial begin
       repeat (100000) #5 filter = ~filter;
    end

    initial begin
       filter = 0;
       orig = 0;
       #100 orig = 1;
       #50 orig = 0;
    end
endmodule
