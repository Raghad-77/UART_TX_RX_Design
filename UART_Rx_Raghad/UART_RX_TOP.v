module UART_RX_TOP#(parameter DATA_WIDTH = 8)(
    input clk,rst,   
    input RX_IN,
    input [5:0]Prescale,
    input PAR_EN, PAR_TYP,
    output wire Data_Valid, par_err, stp_err,
    output  wire  [DATA_WIDTH-1:0] P_DATA
);

wire [2:0]bit_cnt;
wire bit_done;
wire stp_chk_en;
wire strt_glitch;
wire strt_chk_en;
wire par_chk_en;
wire deser_en;
wire data_samp_en;
wire edge_count_enable;
wire bit_count_enable;
wire sampling_done;
wire [4:0]edge_cnt;
wire sampled_bit;

FSM_RX U1_FSM(clk,rst,bit_cnt,RX_IN,PAR_EN,bit_done,
strt_glitch,par_err,stp_err,par_chk_en,strt_chk_en,
stp_chk_en,Data_Valid,deser_en,data_samp_en,edge_count_enable,bit_count_enable);

EDGE_BIT_COUNTER U1_EDGE_BIT_COUNTER(clk,rst,edge_count_enable,bit_count_enable,
Prescale,bit_cnt,edge_cnt,bit_done);

DESERIALIZER U1_DESERIALIZER(clk,rst,sampled_bit,deser_en,P_DATA);

DATA_SAMPLING U1_DATA_SAMPLING(clk,rst,RX_IN,Prescale,data_samp_en,
edge_cnt,sampling_done,sampled_bit);

PARITY_CHECK U1_PARITY_CHECK(clk,rst,PAR_TYP,par_chk_en,
sampled_bit,sampling_done,P_DATA,par_err);

START_CHECK U1_START_CHECK(clk,rst,strt_chk_en,sampled_bit,strt_glitch);

STOP_CHECK U1_STOP_CHECK(clk,rst,stp_chk_en,sampling_done,sampled_bit,stp_err);

endmodule