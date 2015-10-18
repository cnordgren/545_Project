`timescale 1ns / 1ps

module xorDisplayer(
    input logic [15:0] sw,
    input logic btnC,
    output logic [7:0] led
    );
    
    always_comb begin
        if (btnC == 1)
            led[7:0] = sw[7:0] ^ sw[15:8];
        else
            led[7:0] = 8'd0;
    end
    
endmodule
