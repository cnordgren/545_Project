module microprocessor(clk, rst, IRQRES, DI, R_W, DO, AB );
    input  logic        clk, rst, IRQRES;
    input  logic [7:0]  DI;
    output logic        R_W;    
    output logic [7:0]  DO;
    output logic [15:0] AB;



    logic NMI;
    logic RDY; 

    assign NMI = 1'b1;
    assign RDY = 1'b1;
    
    cpu      six502(.clk(clk), .reset(rst), .AB(AB), .DI(DI), .DO(DO), .WE(R_W), .IRQ(IRQRES), .NMI(NMI), .RDY(RDY));




endmodule

