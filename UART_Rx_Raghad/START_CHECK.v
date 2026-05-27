module START_CHECK (
    input CLK,RST,
    input strt_chk_en, sampled_bit,
    output reg strt_glitch
);
    
always @(posedge CLK or negedge RST) begin
    if (!RST) 
        strt_glitch <=0;
    else if (strt_chk_en) 
        strt_glitch <= sampled_bit;  
    else
        strt_glitch <= 0;
end
endmodule