module distortion_tb();
    logic in, filter, out;

    distortion d(in, filter, out);

    initial begin
       #10 in = 1'b1;
           filter = 1'b1;
       #50 filter = 1'b0;
    end

endmodule
