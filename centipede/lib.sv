`ifndef lib_sv_
`define lib_sv_

// Contains all generic datapath components

/* This is a mux that has INPUTS inputs, each with WIDTH size, and an output
 * of course with WIDTH size */
module mux
    #(parameter INPUTS=4, WIDTH=8)
    (input  logic [INPUTS-1:0][WIDTH-1:0] in,
     input  logic [$clog2(INPUTS)-1:0]    sel,
     output logic [WIDTH-1:0]             out);

    assign out = in[sel];

endmodule: mux

// Takes a WIDTH-bit number, and converts it to a one-hot encoding
module decoder_oneCold
    #(parameter WIDTH=2)
    (input  logic [WIDTH-1:0]    sel,
     input  logic                en,
     output logic [2**WIDTH-1:0] out);

     always_comb begin
        out = 'd0;
        if (en)
            out[sel] = 1'b1;
     end

endmodule: decoder_oneCold


/* A counter parametrized by its starting and MAXIMUM values. It can also be
 * optionally loaded with a value, and the counting can proceed from there. The
 * precedance of the inputs are as follows: clear, load, up/down. */
module counter
    #(parameter START=0, MAX=3)
    (input  logic                   clk, rst_l, clear, up, down,
     output logic [$clog2(MAX)-1:0] count);

    always_ff @(posedge clk, negedge rst_l) begin
        if (~rst_l || clear)
            count <= START;
        else if (down && up)
            count <= count;
        else if (down)
            count <= (count == 'd0) ? MAX : count - 1;
        else if (up)
            count <= (count == MAX) ? 'd0 : count + 1;
    end

endmodule: counter

/* A register parametrized by the width of the input, with an asynchronous,
 * asserted low reset. The starting value is also parameterized. */
module register
   #(parameter WIDTH=8, RESET_VAL=0)
    (input  logic             clk, en, rst_l, reset,
     input  logic [WIDTH-1:0] D,
     output logic [WIDTH-1:0] Q);

     always_ff @(posedge clk, negedge rst_l) begin
         if (~rst_l | reset)
             Q <= RESET_VAL;
         else if (en)
             Q <= D;
     end

endmodule:register

/* A parallel-in, serial-out shift register (PISO), parameterized by WIDTH,
 * with the ability to either left or right shift */
module piso
    #(parameter WIDTH=8)
    (input  logic             clk, rst_l, load, left, right,
     input  logic [WIDTH-1:0] D,
     output logic             data_out);

    logic [WIDTH-1:0] reg_val;

    always_ff @(posedge clk, negedge rst_l) begin
        if (~rst_l)
            reg_val <= 'd0;
        else if (load)
            reg_val <= D;
        else if (right && ~left)
            reg_val <= reg_val >> 1;
        else if (left && ~right)
            reg_val <= reg_val << 1;
    end

    assign data_out = (left) ? reg_val[WIDTH-1] : reg_val[0];

endmodule: piso


module sipo
    #(parameter WIDTH=8)
    (input  logic             clk, rst_l, reset, left, right, data_in,
     output logic [WIDTH-1:0] data_out);

    logic [WIDTH-1:0] reg_val;

    always_ff @(posedge clk, negedge rst_l) begin
        if (~rst_l | reset)
            reg_val <= 'd0;
        else if (~right & left)
            reg_val <= data_out << 1 | data_in;
        else if (~left & right)
            reg_val <= (data_in << (WIDTH-1)) | (reg_val >> 1);
    end

    assign data_out = reg_val;

endmodule: sipo

`endif
