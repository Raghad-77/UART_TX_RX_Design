module DATA_SAMPLING(
    input clk,rst,
    input RX_IN,
    input  [5:0]Prescale,
    input  data_samp_en,
    input  [4:0]edge_cnt,
    output reg sampling_done,
    output reg sampled_bit
);

wire [4:0] half_e;
reg [2:0] samples;
assign half_e = Prescale >> 1;

always @(posedge clk or negedge rst) begin
    if (!rst) 
        samples <= 0;
    else if (data_samp_en) 
    begin
        if(edge_cnt == (half_e - 4'b1))
            samples[0] <= RX_IN;
        else if(edge_cnt == half_e)
            samples[1] <= RX_IN;
        else if(edge_cnt == (half_e + 4'b1)) 
            samples[2] <= RX_IN;
    end
    else 
        samples <= 0;
end

always @(posedge clk or negedge rst) begin
    if (!rst) 
        sampling_done <= 0;
    else if (edge_cnt == (half_e + 4'b1)) 
        sampling_done <= 1;
    else 
        sampling_done <= 0;
end

always @(*) begin
    if ((half_e == 4'd2) && (edge_cnt == 5'd2)) 
    begin
        sampled_bit = RX_IN;
    end
    else begin
        case (samples)
            3'b000: sampled_bit =0;
            3'b001: sampled_bit =0;
            3'b010: sampled_bit =0;
            3'b100: sampled_bit =0;
            3'b011: sampled_bit =1;
            3'b101: sampled_bit =1;
            3'b110: sampled_bit =1;
            3'b111: sampled_bit =1;
        endcase
    end
end
endmodule