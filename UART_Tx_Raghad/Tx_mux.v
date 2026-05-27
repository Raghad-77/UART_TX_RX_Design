module Tx_mux(
    input clk,rst,
    input [1:0]sel,
    input start,stop,data_ser,parity_bit,
    output reg TX_OUT
);    

reg Omux;
always @(posedge clk or negedge rst) begin
    if(!rst)
        TX_OUT<=1;
    else
        TX_OUT<=Omux;
end
    
always @(*) begin
    case(sel)
    2'b00: Omux=start;
    2'b01: Omux=data_ser;
    2'b10: Omux=parity_bit;
    2'b11: Omux=stop;
    default:Omux=stop;
    endcase
end
endmodule