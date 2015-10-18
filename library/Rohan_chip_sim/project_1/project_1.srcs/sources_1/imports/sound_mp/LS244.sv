

/*
   When enable is low y==0 or 1
   When enable is high y = z
*/
module tristate_buffer (
   input  logic  x,
   input  logic  en,
   output logic  y
);

   assign y = en ? x : 1'bz;

endmodule

//follow I/O diagram on LS244 datasheet
module LS244 (
   input  logic [7:0] A,
   input  logic       en_A, 
   input  logic       en_B, 
   output logic [7:0] Q);

  
     tristate_buffer            tsb0 (A[0], ~en_A, Q[0]);
     tristate_buffer            tsb1 (A[1], ~en_A, Q[1]);
     tristate_buffer            tsb2 (A[2], ~en_A, Q[2]);
     tristate_buffer            tsb3 (A[3], ~en_A, Q[3]);
     tristate_buffer            tsb4 (A[4], ~en_B, Q[4]);
     tristate_buffer            tsb5 (A[5], ~en_B, Q[5]);
     tristate_buffer            tsb6 (A[6], ~en_B, Q[6]);
     tristate_buffer            tsb7 (A[7], ~en_B, Q[7]);


endmodule: LS244

