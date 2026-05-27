module parity #(parameter WIDTH = 8)(
    input clk,rst,
    input [WIDTH-1:0]Data,
    input Data_Valid,busy,
    input par_typ, 
    //0: Even parity bit
    //1: Odd parity bit
    output reg par_bit
);

always @(posedge clk or negedge rst) begin
    if (!rst) 
        par_bit <= 0;
    else if (Data_Valid && !busy) begin
        case (par_typ)
            1'b0: par_bit <= ^Data;   // Even
            1'b1: par_bit <= ~^Data;  // Odd
        endcase
    end
end
endmodule