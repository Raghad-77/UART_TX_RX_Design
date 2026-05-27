module DESERIALIZER #(parameter DATA_WIDTH = 8)(
    input CLK,RST,           
    input sampled_bit, deser_en,
    output  wire [DATA_WIDTH-1:0]  P_DATA
);
    
reg [DATA_WIDTH-1:0] de_serializer; 

always @(posedge CLK or negedge RST) begin
    if (!RST) 
        de_serializer <=0;
    else if (deser_en) 
        de_serializer <= {sampled_bit, de_serializer[7:1]};
end

assign P_DATA = de_serializer;

endmodule