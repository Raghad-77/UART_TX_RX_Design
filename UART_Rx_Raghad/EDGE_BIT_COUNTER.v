module EDGE_BIT_COUNTER(
    input clk,rst,
    input edge_count_en,bit_count_en,
    input [5:0]Prescale,
    output wire [2:0]bit_cnt,
    output wire [4:0]edge_cnt,
    output wire bit_done
);

wire [4:0] prescale_m1;
assign prescale_m1 = Prescale - 1;

reg [4:0] edge_cnt_reg;
always @(posedge clk or negedge rst) begin
    if (!rst) 
        edge_cnt_reg <= 0;
    else if(edge_count_en) 
    begin
        if (bit_done) 
            edge_cnt_reg <= 0;
        else 
            edge_cnt_reg <= edge_cnt_reg +1;
    end
end

reg [2:0] bit_cnt_reg;

always @(posedge clk or negedge rst) begin
    if (!rst) 
        bit_cnt_reg <= 0;
    else if(bit_done && bit_count_en) 
            bit_cnt_reg <= bit_cnt_reg + 1;
    else if (!bit_count_en) 
            bit_cnt_reg <= 0;
end

assign edge_cnt = edge_cnt_reg;
assign bit_cnt = bit_cnt_reg;
assign bit_done = (edge_cnt_reg == prescale_m1);

endmodule