/*
I2S Interface for PMOD I2S

*/

module dff
   (input  logic d,
    input  logic clk, rst_l,
    output logic q);

    always_ff @(negedge rst_l, posedge clk)
       if (~rst_l)
          q <= 1'b0;
       else
          q <= d;

endmodule: dff

//shift by certain value(shift_in)
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


/*
SCK - serial clock
WS - indicates left or right channel
SD - serial data signal
*/
module I2S_interface
   (input   logic           WS, SCK, rst_l,
    input   logic [15:0]    left_data, right_data,
    output  logic           SD);
    
    logic           q2OUT, WSP, WSD;
    logic   [15:0]  data_in;
    
    dff d0(.d(WS), .clk(SCK), .rst_l(rst_l), .q(WSD));
    dff d1(.d(WSD), .clk(SCK), .rst_l(rst_l), .q(q2OUT));
    
    assign WSP = WSD ^ q2OUT;
    assign data_in = (WSD) ? right_data : left_data;

    piso #(16) pisoREG(.clk(~SCK), .rst_l(rst_l), .load(WSP),
                       .left(1'b1), .right(1'b0), .D(data_in), .data_out(SD));

endmodule
