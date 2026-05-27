module FSM_RX#(parameter DATA_WIDTH = 8)(
    input clk,rst,
    input [2:0]bit_cnt,
    input  RX_IN,PAR_EN,edge_cnt,strt_glitch, par_err, stp_err,
    output reg par_chk_en,strt_chk_en,stp_chk_en,Data_Valid,
    output reg deser_en,data_samp_en,
    output reg edge_count_en, //enable wire
    output reg bit_count_en
);

 localparam  [2:0]  IDLE= 3'b000,
                    START= 3'b001,
                    DESERIALIZE= 3'b011,
                    PARITY= 3'b010,
                    STOP= 3'b110,
                    OUTPUT= 3'b111;

reg [2:0] CS, NS;

always @(posedge clk or negedge rst) begin
    if(!rst) 
        CS <= IDLE;
    else 
        CS <= NS;
end

always @(*) begin
    stp_chk_en= 0;
    strt_chk_en= 0;
    par_chk_en= 0;
    deser_en= 0;
    data_samp_en= 0;
    edge_count_en= 0;
    bit_count_en= 0;
    Data_Valid= 0;
    case (CS)
    IDLE: 
    begin
        if (RX_IN) 
            NS = IDLE;  
        else 
            NS = START; 
    end 
    START: 
    begin
        if (edge_cnt) 
        begin
            if (strt_glitch)
                NS = IDLE;
            else  
                NS = DESERIALIZE;
        end
        else 
            NS = START;
        strt_chk_en =1;
        edge_count_en =1;
        data_samp_en =1;
    end
    DESERIALIZE: 
    begin
        if (bit_cnt == (DATA_WIDTH - 1) && edge_cnt) 
        begin
            if (PAR_EN) 
                NS = PARITY;
            else 
                NS = STOP;
        end
        else 
            NS = DESERIALIZE;
        if (edge_cnt) begin
        deser_en =1;
        end
        edge_count_en =1;
        bit_count_en =1;
        data_samp_en =1;
    end
    PARITY: 
    begin
        if (edge_cnt) 
        begin
            if (par_err) 
                NS = IDLE;
            else
                NS = STOP;
        end
        else 
            NS = PARITY;
        par_chk_en =1;
        edge_count_en =1;
        data_samp_en = 1;
    end
    STOP: 
    begin
        if (edge_cnt) begin
            if (stp_err)
                NS = IDLE;
            else
                NS = OUTPUT;
        end
        else 
            NS = STOP;

        stp_chk_en =1;
        edge_count_en=1;
        data_samp_en =1;
    end
    OUTPUT: 
    begin
        if(RX_IN) 
            NS = IDLE;
        else 
            NS = START;
            
        Data_Valid = 1;
    end
    default: NS = IDLE;
    endcase
end

endmodule