//follow I/O diagram on LS255 datasheet
module LS255 (
   input  logic [7:0] A,
   input  logic       DIR, OE,
   output logic [7:0] B
);

   logic q, r;

   assign q = DIR && ~OE;
   assign r = ~DIR && ~OE;

   tristate_buffer   tsb0(A[0], q, B[0]);
   tristate_buffer   tsb1(B[0], r, A[0]);
   tristate_buffer   tsb2(A[1], q, B[1]);
   tristate_buffer   tsb3(B[1], r, A[1]);
   tristate_buffer   tsb4(A[2], q, B[2]);
   tristate_buffer   tsb5(B[2], r, A[2]);
   tristate_buffer   tsb6(A[3], q, B[3]);
   tristate_buffer   tsb7(B[3], r, A[3]);
   tristate_buffer   tsb8(A[4], q, B[4]);
   tristate_buffer   tsb9(B[4], r, A[4]);
   tristate_buffer   tsb10(A[5], q, B[5]);
   tristate_buffer   tsb11(B[5], r, A[5]);
   tristate_buffer   tsb12(A[6], q, B[6]);
   tristate_buffer   tsb13(B[6], r, A[6]);
   tristate_buffer   tsb14(A[7], q, B[7]);
   tristate_buffer   tsb15(B[7], r, A[7]);





endmodule: LS255




