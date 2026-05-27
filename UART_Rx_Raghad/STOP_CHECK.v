module STOP_CHECK (
    input clk,rst,
    input stp_chk_en, sampling_done, sampled_bit,
    output reg stp_err
);
    
always @(posedge clk or negedge rst) begin
    if (!rst) 
        stp_err <= 0;
    else if(stp_chk_en && sampling_done)
        stp_err <= !sampled_bit;  
    else if (!stp_chk_en) 
        stp_err <= 0;
end

endmodule