//tristate_buffer

module testbench_tristate_buffer;
   bit x, y, en;
  bit clk;

  bit [10:0] counter;
  always_ff@(posedge clk) begin

    counter <= counter + 1;
    
  end
    
    tristate_buffer            tb0(x, en, y);
    assign en = 1'b1;
    assign x = counter[5];
   initial begin
      //#10 x = 1'b1;
      #100 $display("x=%b, en=%b, y=%b", x, en, y);
      repeat (100000) #5 clk = ~clk;
   end
endmodule

module testbench_LS244;
   bit [7:0] A, Q;
   bit       en_A, en_B;

   bit clk;
   bit [10:0] counter;

   always_ff@(posedge clk) begin
     
     counter <= counter + 1;
   end

   assign en_A = 1'b1;
   assign en_B = 1'b0;
   
   always_comb begin
      A[0] = counter[5];
      A[1] = counter[6];
      A[2] = counter[7];
      A[3] = counter[8];
      A[4] = counter[9];
      A[5] = counter[10];
                
   
   
   
   end
   initial begin
      #10 $display("A=%b, en_A=%b, en_B=%b, Q=%b", A, en_A, en_B, Q);
      repeat (100000) #5 clk = ~clk;

   end

endmodule







