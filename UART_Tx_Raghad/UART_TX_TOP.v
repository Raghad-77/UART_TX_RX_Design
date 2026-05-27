module UART_TX_TOP#(parameter W = 8)(
    input [W-1:0] P_DATA,
    input CLK,RST,PAR_TYP,PAR_EN,DATA_VALID,
    output wire TX_OUT,busy
);
wire ser_done,ser_en,par_bit,ser_data;
wire [1:0] sel;

TX_FSM ufsm(
    .clk(CLK),
    .rst(RST),
    .Data_Valid(DATA_VALID),
    .PAR_EN(PAR_EN),
    .Ser_done(ser_done),
    .sel(sel),
    .busy(busy),
    .Ser_en(ser_en));

parity # (.WIDTH(W)) uParity(CLK,RST,P_DATA,DATA_VALID,busy,PAR_TYP,par_bit);

serializer # (.WIDTH(W)) uSerializer(CLK,RST,P_DATA,ser_en,busy,DATA_VALID,ser_done,ser_data); 

Tx_mux umux(
    .clk(CLK),
    .rst(RST),
    .sel(sel),
    .start(1'b0),
    .stop(1'b1),
    .data_ser(ser_data),    
    .parity_bit(par_bit),
    .TX_OUT(TX_OUT));

endmodule