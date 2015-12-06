module address_decoder(input  logic  [15:0] AB, 
                       input  logic  WRITE, BR_W, 
                       input  logic  GMHZ, PAC,
                       output logic  ROM, WRITE_2,
                       output logic  [3:0] rom,
                       output logic  STEERCLR, WATCHDOG, OUT0,
                       output logic  IRQRES, POKEY, SWRD,
                       output logic  PF, RAM0, COLORRAM,
                       output logic  NinetyNine, EA_READ,
                       output logic  EA_CONTROL, EA_ABOR, INQ,
                       output logic  INI, PFRAMRD,
                       output logic  [3:0] PFWR);
    
    logic [15:0] ls42_out;
    logic [3:0]  ls139m_out;
    logic        A8H2, C5P1, U550, L9UCB, OUA5, F733, L4231;
    logic        L3580, L4P5C, AOOH, F6HP, F97A, ls139_en;


    //output for ls42
    always_comb begin
        A8H2 = ~ls42_out[9];
        C5P1 = ~ls42_out[8];
        U550 = ~ls42_out[7];
        L9UCB = ~ls42_out[6];
        OUA5 = ~ls42_out[5];
        F733 = ~ls42_out[4];
        L4231 = ~ls42_out[3];
        L3580 = ~ls42_out[2];
        L4P5C = ~ls42_out[1];
        AOOH = ~ls42_out[0];

    end

    assign POKEY = F733;
    assign SWRD = L3580;
    assign PF = L4P5C;
    assign RAM0 = AOOH;
    //assign RAM0 = (~AB[13] & ~AB[12] & ~AB[11] & ~AB[10]);
    
    //output for ls139(middle chip in diagram)
    always_comb begin
        NinetyNine = ls139m_out[3];
        EA_READ = ls139m_out[2];
        EA_CONTROL = ls139m_out[1];
        EA_ABOR = ls139m_out[0];
    end

     assign ROM = ~AB[13];
    //assign ROM = (BR_W | (~AB[13]));
    //assign ROM = (~RAM0 & (BR_W | (~AB[13])));
    //assign ROM =  ~((~BR_W) & AB[13]);
    assign WRITE_2 = ~(GMHZ & (~WRITE));
    assign STEERCLR = (WRITE_2 | A8H2);
    assign WATCHDOG = (WRITE_2 | C5P1);
    assign OUT0 = (WRITE_2 | U550);
    assign IRQRES = (WRITE_2 | L9UCB);

    assign F6HP = (AB[9] | OUA5);
    assign F97A = (OUA5 | (~AB[9]));
    assign COLORRAM = (F6HP | PAC); 

    assign INQ = (L4231 | AB[1]);
    assign INI = (L4231 | (~AB[1]));
    assign PFRAMRD = (BR_W | L4P5C);
    assign ls139_en = (WRITE | L4P5C);

    decoder  #(4) LS42(.sel(AB[13:10]), .en(1'b1), .out(ls42_out));

    decoder  #(2) LS139T(.sel(AB[12:11]), .en(~ROM), .out(rom));

    decoder  #(2) LS139M(.sel(AB[8:7]), .en(~F97A), .out(ls139m_out));

    decoder  #(2) LS139B(.sel(AB[5:4]), .en(~ls139_en), .out(PFWR));


endmodule
