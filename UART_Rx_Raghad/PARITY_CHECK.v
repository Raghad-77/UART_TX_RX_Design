module PARITY_CHECK#(parameter DATA_WIDTH = 8)(
    input  CLK,RST,
    input PAR_TYP, par_chk_en, sampled_bit, sampling_done,
    input [DATA_WIDTH-1:0] P_DATA,
    output reg par_err
);

reg par_res;

always @(posedge CLK or negedge RST) begin
    if (!RST) 
        par_err <= 0;
    else if (sampling_done && par_chk_en) 
        par_err <= (sampled_bit != par_res);
    else if (!par_chk_en) 
        par_err <= 0;
end


localparam  EVEN_PARITY = 0;

always @(posedge CLK or negedge RST) begin
    if (!RST) 
        par_res <= 0;
    else if (PAR_TYP == EVEN_PARITY) 
        par_res <= ^P_DATA; //even
    else 
        par_res <= ~^P_DATA;  //Odd 
end
endmodule