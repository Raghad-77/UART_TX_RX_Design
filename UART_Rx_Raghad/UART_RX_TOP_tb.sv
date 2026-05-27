`timescale 1ns/1ps

module UART_RX_TOP_tb;
localparam DATA_WIDTH = 8;
reg                     clk,rst;
reg                     RX_IN;
reg  [5:0]              Prescale;
reg                     PAR_EN,PAR_TYP;
logic                    Data_Valid, par_err, stp_err;
logic [DATA_WIDTH-1:0]   P_DATA;

localparam even_parity = 0;
localparam odd_parity = 1;

integer error_count,correct_count;

UART_RX_TOP DUT (clk,rst,RX_IN,Prescale,PAR_EN,PAR_TYP,Data_Valid,par_err,stp_err,P_DATA);

localparam CLK_Period = 10;

always #(CLK_Period/2) clk = ~ clk;
    
initial begin
    initialzie();
    reset();
    //Test 1: Data frame with EVEN parity
    // One start bit, 8 data bits, even parity, one stop bit

    Prescale = 6'd16;
    sendframe(8'b1010_1100, 1, even_parity, ^8'b1010_1100, 1);
    check_output(8'b1010_1100,0,0, "Frame with EVEN parity");

    #(CLK_Period);

    // TEST 2: Data frame with ODD parity
    // One start bit, 8 data bits, odd parity, one stop bit
    Prescale = 6'd16; 
    sendframe(8'b0101_0011, 1, odd_parity, ~^8'b0101_0011, 1);
    check_output(8'b0101_0011,0,0, "Frame with ODD parity");

    #(CLK_Period);

    // TEST 3: Data frame with NO parity
    // One start bit, 8 data bits, one stop bit
    Prescale = 6'd16; 
    sendframe(8'b1111_0000, 0, 0, 0, 1);
    check_output(8'b1111_0000,0, 0, "Frame with NO parity");

    #(CLK_Period);

    // CASE 4: Prescales
    Prescale = 6'd8;
    sendframe(8'b1100_0011, 0, 0, 0, 1);
    check_output(8'b1100_0011,0, 0, "Frame with prescale=8");

    #(CLK_Period);

    Prescale = 6'd16;
    sendframe(8'b0011_1100, 0, 0, 0, 1);
    check_output(8'b0011_1100,0,0, "Frame with prescale=16");

    #(CLK_Period);

    Prescale = 6'd32;
    sendframe(8'b1001_0110, 0, 0, 0, 1);
    check_output(8'b1001_0110,0, 0, "Frame with prescale=32");
    
    #(CLK_Period);

    $display("number of passed test cases=%d  | number of failed test cases=%d ",correct_count,error_count);
    $stop;

    end


task initialzie;
    clk=0;
    RX_IN = 1;
    Prescale = 0;
    PAR_EN = 1;
    PAR_TYP = 0;   
    error_count=0; correct_count=0; 
endtask
    
task reset;
    rst = 1;
    #(CLK_Period);
    rst = 0;
    #(CLK_Period);
    rst = 1;
endtask
    
task sendframe (input [DATA_WIDTH-1:0] data,input parity_en, parity_type, parity_bit, stop_bit);
    PAR_EN = parity_en;
    RX_IN = 0; 

    repeat (Prescale) @(negedge clk);
    RX_IN = data[0]; 

    repeat (Prescale) @(negedge clk);        
    RX_IN = data[1]; 

    repeat (Prescale) @(negedge clk);        
    RX_IN = data[2]; 

    repeat (Prescale) @(negedge clk);        
    RX_IN = data[3]; 

    repeat (Prescale) @(negedge clk);        
    RX_IN = data[4]; 

    repeat (Prescale) @(negedge clk);        
    RX_IN = data[5]; 

    repeat (Prescale) @(negedge clk);        
    RX_IN = data[6]; 

    repeat (Prescale) @(negedge clk);        
    RX_IN = data[7]; 

    repeat (Prescale) @(negedge clk);
    if(parity_en) begin
        PAR_TYP = parity_type;
        RX_IN = parity_bit; 
        repeat (Prescale) @(negedge clk);
    end
    RX_IN = stop_bit;  //sending stop bit
    repeat (Prescale) @(negedge clk);
    RX_IN = 1;  //return to IDLE
endtask
    
task check_output(
        input [DATA_WIDTH-1:0] expected_data,
        input expected_par_err, expected_stp_err,
        input string msg);

@(negedge clk);
        if ((P_DATA === expected_data) &&
            (par_err === expected_par_err) &&
            (stp_err === expected_stp_err)) begin
            $display("PASSED: %s | P_DATA=%b", msg, P_DATA);
            correct_count+=1;
        end
        else begin
            $display("FAILED: %s | Got P_DATA=%b,ParErr=%b, StpErr=%b",
                   msg, P_DATA, par_err, stp_err);
            error_count+=1;
        end
endtask
endmodule